{ pkgs, lib, inputs, nvidiaPackages, config, ... }:
{
  home = {
    username = lib.mkDefault "jspspike";
    homeDirectory = lib.mkDefault "/home/jspspike";
    packages = with pkgs; [];
  };
  programs = {
    git = {
      userName = "jspspike";
      userEmail = "jspspike@gmail.com";
    };
  };

  jspspike.graphicsWrapper = {
    kind = "nvidia";
    version = "545.29.06";
    sha256 = "sha256-grxVZ2rdQ0FsFG5wxiTI3GrxbMBMcjhoDFajDgBFsXs=";
  };
}