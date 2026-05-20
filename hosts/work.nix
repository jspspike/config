{ pkgs, lib, inputs, config, ... }:
{
  home = {
    username = "jjohnson";
    homeDirectory = "/home/jjohnson";
    packages = with pkgs; [
      tcpflow opencode
    ];
  };
  programs = {
    git = {
      settings = {
        user.name = "jjohnson";
        user.email = "jjohnson@cloudflare.com";
      };
      ignores = ["local-patches/"];
    };
    kitty = {
      settings = {
        font_size = 10.0;
        shell = "${pkgs.zsh}/bin/zsh";
      };
    };
  };

  home.file.".local/bin/sway-launch" = {
    executable = true;
    text = ''
      #!/bin/sh
      exec ${config.lib.nixGL.wrap pkgs.sway}/bin/sway --unsupported-gpu "$@"
    '';
  };

  systemd.user.sessionVariables = {
    WLR_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";
  };

  wayland.windowManager.sway.config = {
    workspaceOutputAssign = [
      { workspace = "1"; output = "eDP-1"; }
      { workspace = "2"; output = "eDP-1"; }
      { workspace = "3"; output = "DVI-I-1"; }
      { workspace = "4"; output = "eDP-1"; }
      { workspace = "5"; output = "DVI-I-1"; }
    ];
    output = {
      eDP-1 = {
        mode = "2880x1800@60Hz";
        position = "0 400";
        background = "#2F4970 solid_color";
      };
      DVI-I-1 = {
        mode = "3840x2160@59.997Hz";
        scale = "1.4";
        position = "1440 0";
        background = "#2F4970 solid_color";
      };
    };
  };

  imports = [ ../home-modules/sway.nix ];
}
