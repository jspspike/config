{ inputs, pkgs, ... }:
{
  imports = [ ./configuration.nix inputs.home-manager.nixosModules.home-manager  ];

  nix.settings.extra-experimental-features = [ "flakes" "nix-command" ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.jspspike.imports = [ ../../home-modules/common.nix ../../home-modules/sway.nix ];
    users.jspspike = {
      wayland.windowManager.sway.config = {
        output = {
          HDMI-A-2 = {
            mode = "1920x1080@120Hz";
            background = "#2F4970 solid_color";
          };
        };
      };
    };
  };
}
