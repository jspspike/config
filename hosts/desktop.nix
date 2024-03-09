{ pkgs, lib, inputs, nvidiaPackages, config, ... }: let
  gWrap = config.jspspike.graphicsWrapper.functions;
in {
  home = {
    packages = with pkgs; [ (gWrap.opengl discord) spotify ];

  };
  programs = {
  };

  jspspike.graphicsWrapper = {
    kind = "nvidia";
    version = "550.54.14";
    sha256 = "sha256-jEl/8c/HwxD7h1FJvDD6pP0m0iN7LLps0uiweAFXz+M=";
  };
}
