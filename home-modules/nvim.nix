# Taken from https://github.com/P1n3appl3/config/blob/main/mixins/home-manager/nvim.nix
{ inputs, pkgs, ... }:
{
  imports = [ "${inputs.pineapple}/mixins/home/nvim.nix" ];
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [lush-nvim rustaceanvim nvim-lspconfig neodev-nvim

    (nvim-treesitter.withPlugins (p: with p; [
      bash c cpp python rust lua zig kdl toml ini json json5 jq regex query
      make ninja dot nix html css scss typescript javascript markdown markdown-inline
      git-config git-rebase gitcommit gitignore udev passwd
      gdscript gdshader glsl wgsl wgsl-bevy hlsl
      typst beancount rasi yuck vim vimdoc forth asm nasm
    ]))
    nvim-treesitter-textobjects nvim-treesitter-context
  ];
  extraLuaPackages = ps: [ ps.magick ];
  };
  home.packages = with pkgs; [ lua-language-server typescript-language-server imagemagick ];
}
