{ inputs, pkgs, ... }:
let
  androidMessages = pkgs.callPackage "${inputs.pineapple}/pkgs/android-messages.nix" {};
in
{
  imports = [ ./configuration.nix inputs.home-manager.nixosModules.home-manager  ];

  users.users.jspspike.packages = with pkgs; [ discord spotify androidMessages ];

  nix.settings.extra-experimental-features = [ "flakes" "nix-command" ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.jspspike.imports = [ ../../home-modules/common.nix ../../home-modules/i3.nix ];
  };
}
