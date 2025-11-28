{ config, pkgs, inputs, ... }:

{
  imports =
    [ ./hardware-configuration.nix ../../machine-modules/sway.nix ../../machine-modules/common.nix ../../secrets/config.nix ];

  programs = {
    steam.enable = true;
  };

  users.users.jspspike.packages = with pkgs; [ discord spotify inputs.pineapple.packages.x86_64-linux.android-messages ];
}
