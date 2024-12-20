{ inputs, ... }:
{
  imports = [ ./configuration.nix inputs.home-manager.nixosModules.home-manager  ];

  nix.settings.extra-experimental-features = [ "flakes" "nix-command" ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.jspspike.imports = [ ../../home-modules/common.nix ../../home-modules/i3.nix ];
  };
}
