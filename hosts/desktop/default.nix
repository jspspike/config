{ inputs, lib, ... }:
{
  imports = [ ./configuration.nix inputs.home-manager.nixosModules.home-manager  ];

  nix.settings.extra-experimental-features = [ "flakes" "nix-command" ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.jspspike.imports = [ ../../home-modules/common.nix ../../home-modules/sway.nix ];
    users.jspspike = {
      wayland.windowManager.sway.config = {
        output = {
          DP-2 = {
            mode = "2560x1440@144Hz";
            position = "1440,630";
            background = "#2F4970 solid_color";
          };
          DP-3 = {
            mode = "2560x1440@144Hz";
            position = "0,0";
            transform = "270";
            background = "#2F4970 solid_color";
          };
        };
        assigns = {
          "2" = [
            { app_id = "org.telegram.desktop"; }
            { title = "Android Messages"; }
          ];
        };
        workspaceOutputAssign = [
          { workspace = "1"; output = "DP-2"; }
          { workspace = "2"; output = "DP-3"; }
        ];
      };
    };
  };
}
