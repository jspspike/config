local M = {}

local state = {
    rev = nil, -- revision as the user spelled it, e.g. "HEAD^"
    base = nil, -- that revision resolved to a short sha
    bufs = {}, -- buffers this module added to the buffer list
}

local function notify(msg, level)
    vim.notify(msg, level or vim.log.levels.INFO, { title = "GitDiff" })
end

--- @return string? stdout, string? stderr
local function git(args, cwd)
    local res = vim.system(vim.list_extend({ "git" }, args), { cwd = cwd, text = true }):wait()
    if res.code ~= 0 then return nil, vim.trim(res.stderr or "") end
    return res.stdout
end

--- Repository containing the current buffer, falling back to the cwd.
local function toplevel()
    local name = vim.api.nvim_buf_get_name(0)
    local dir = name ~= "" and vim.fs.dirname(name) or vim.uv.cwd()
    local out = git({ "rev-parse", "--show-toplevel" }, dir)
    return out and vim.trim(out) or nil
end

function M.active() return state.base ~= nil end

function M.status()
    if not state.base then return "" end
    return "%#OrangeSign# GITDIFF " .. state.base .. " %*"
end

--- Wrap a gitsigns hunk action so it refuses to run while a diff base is set.
--- Hunks are computed against the base, so staging or resetting one while a
--- diff is active would write that commit's content into the working tree.
function M.guard(name, action)
    return function()
        if state.base then
            notify(("%s is disabled in git diff mode (base %s)"):format(name, state.base), vim.log.levels.WARN)
            return
        end
        action()
    end
end

function M.start(rev)
    rev = (rev and rev ~= "") and rev or "HEAD^"

    local top = toplevel()
    if not top then return notify("not inside a git repository", vim.log.levels.ERROR) end

    local sha, rev_err = git({ "rev-parse", "--verify", "--short", rev .. "^{commit}" }, top)
    if not sha then
        return notify(("bad revision %q: %s"):format(rev, rev_err), vim.log.levels.ERROR)
    end
    sha = vim.trim(sha)

    -- Diff against the working tree rather than HEAD so uncommitted work stays
    -- visible, matching what the signs show. Deletions are excluded because
    -- they have no file left to open.
    local out, diff_err = git({ "diff", "-z", "--name-only", "--diff-filter=d", sha }, top)
    if not out then return notify("git diff failed: " .. diff_err, vim.log.levels.ERROR) end

    vim.cmd.packadd "vim-fugitive"

    -- Pin to the sha so the base does not drift if HEAD moves while active.
    require("gitsigns").change_base(sha, true)

    local before = {}
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
        before[b] = true
    end

    state.rev, state.base, state.bufs = rev, sha, {}

    local n = 0
    for name in vim.gsplit(out, "\0", { plain = true, trimempty = true }) do
        -- Listed but deliberately not loaded: the buffer shows up in the
        -- picker immediately and gitsigns attaches with the global base when
        -- it is actually visited, so large diffs stay instant.
        local buf = vim.fn.bufadd(top .. "/" .. name)
        vim.bo[buf].buflisted = true
        if not before[buf] then state.bufs[buf] = true end
        n = n + 1
    end

    notify(("%s (%s) - %d file%s"):format(rev, sha, n, n == 1 and "" or "s"))
end

function M.stop()
    if not state.base then return notify "not in git diff mode" end

    require("gitsigns").reset_base(true)

    local closed = 0
    for buf in pairs(state.bufs) do
        if
            vim.api.nvim_buf_is_valid(buf)
            and not vim.bo[buf].modified
            and #vim.fn.win_findbuf(buf) == 0
        then
            vim.api.nvim_buf_delete(buf, {})
            closed = closed + 1
        end
    end

    local rev = state.rev
    state.rev, state.base, state.bufs = nil, nil, {}
    notify(("ended %s - closed %d buffer%s"):format(rev, closed, closed == 1 and "" or "s"))
end

local function complete(lead)
    local top = toplevel()
    local refs = { "HEAD^", "HEAD~5", "HEAD~10" }
    if top then
        local out = git({
            "for-each-ref",
            "--format=%(refname:short)",
            "refs/heads",
            "refs/tags",
            "refs/remotes",
        }, top)
        for ref in vim.gsplit(out or "", "\n", { plain = true, trimempty = true }) do
            refs[#refs + 1] = ref
        end
    end
    return vim.tbl_filter(function(r) return vim.startswith(r, lead) end, refs)
end

vim.api.nvim_create_user_command("GitDiff", function(o) M.start(o.args) end, {
    nargs = "?",
    complete = complete,
    desc = "Diff signs against a revision and list every changed file",
})

vim.api.nvim_create_user_command("GitDiffEnd", M.stop, { desc = "Leave git diff mode" })

return M
