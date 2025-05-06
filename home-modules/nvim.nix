# Taken from https://github.com/P1n3appl3/config/blob/main/mixins/home-manager/nvim.nix
{ inputs, pkgs, ... }:
{
  imports = [ "${inputs.pineapple}/mixins/home/nvim.nix" ];
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [lush-nvim rust-tools-nvim nvim-lspconfig];
  };
  home.packages = with pkgs; [ lua-language-server typescript-language-server ];
}
