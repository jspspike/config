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
  };
  jspspike.graphicsWrapper = {
    kind = "intel";
  };
}
