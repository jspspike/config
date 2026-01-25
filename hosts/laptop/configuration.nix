{ config, pkgs, inputs, ... }:
{
  imports =
  [
    ./hardware-configuration.nix
    ../../machine-modules/sway.nix
    ../../machine-modules/common.nix
    ../../secrets/config.nix
    ../../machine-modules/mullvad.nix
  ];

  programs = {
    steam.enable = true;
  };

  users.users.jspspike.packages = with pkgs; [ discord spotify inputs.pineapple.packages.x86_64-linux.android-messages ];

  # Major Elk
  services.mullvad-netns = {
    enable = true;
    privateKeyFile = config.age.secrets.wg-private-laptop.path;
    addressV4 = "10.65.204.227/32";
    addressV6 = "fc00:bbbb:bbbb:bb01::2:cce2/128";
    dnsIp = "10.64.0.1";
  };
}
