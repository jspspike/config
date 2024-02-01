{ pkgs, lib, inputs, nvidiaPackages, config, ... }: let
  gWrap = config.jspspike.graphicsWrapper.functions;
in {
  home = {
    packages = with pkgs; [ (gWrap.opengl discord) ];

  };
  programs = {
  };

  jspspike.graphicsWrapper = {
    kind = "nvidia";
    version = "545.29.06";
    sha256 = "sha256-grxVZ2rdQ0FsFG5wxiTI3GrxbMBMcjhoDFajDgBFsXs=";
  };
}
