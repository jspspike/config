{ pkgs, lib, inputs, nvidiaPackages, config, ... }:
{
  home = {
    packages = with pkgs; [];
  };
  programs = {
  };

  jspspike.graphicsWrapper = {
    kind = "nvidia";
    version = "545.29.06";
    sha256 = "sha256-grxVZ2rdQ0FsFG5wxiTI3GrxbMBMcjhoDFajDgBFsXs=";
  };
}
