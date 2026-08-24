# Rust practices
- Only leave comments if it's something non-trivial, not obvious from the logic. Also don't update method doc comments unless it's something core to the input, output or function of the method. This means leave out information about your thought process or the latest changes made to the function. The comment should contain descriptive information about the field or function itself and only if that information is not obvious from the code
- Avoid using fully qualified paths such as crate::config::rollout::test. Always import at the top of the file first and then use the types/functions. The only exception is when there are generic sounding or similar types between different modules. Then import up to the distinguishing module name and then use those. For example parking_lot::Mutex and tokio::Mutex.

# Local tools
You can use `nix-shell -p <nix package name> --run "<program name>"` to run any programs that might not exist locally. For example `nix-shell -p nodejs --run "npm"`

# git push
When told to push on dolphin or dlp-scanner use the `--no-verify` flag to skip the local tests

# Local repos
Before using the gitlab MCP to read source code look in ~/Projects. There are many relevant repos located there
