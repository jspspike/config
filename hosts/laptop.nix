{ pkgs, lib, inputs, nvidiaPackages, config, ... }:
{
  home = {
    packages = with pkgs; [];
  };
  programs = {
  };

  jspspike.graphicsWrapper = {
    kind = "intel";
  };
}
