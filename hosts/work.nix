{ pkgs, lib, inputs, nvidiaPackages, config, ... }:
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
  };
  jspspike.graphicsWrapper = {
    kind = "intel";
  };
}
