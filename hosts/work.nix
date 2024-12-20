{ pkgs, lib, inputs, config, ... }:
{
  home = {
    username = "jjohnson";
    homeDirectory = "/home/jjohnson";
    packages = with pkgs; [
      tcpflow
    ];
  };
  programs = {
    git = {
      userName = "jjohnson";
      userEmail = "jjohnson@cloudflare.com";
    };
    alacritty = {
      settings = {
        font.size = 10.0;
      };
    };
    kitty = {
      settings = {
        font_size = 18.0;
      };
    };
  };

  imports = [ ../home-modules/i3.nix ];
}
