{ pkgs, lib, inputs, config, ... }:
let
  # xdpw needs GBM/mesa, which a Nix binary can't find on Ubuntu without nixGL.
  # nixGL.wrap only wraps bin/, and xdpw ships in libexec/.
  xdpw = config.lib.nixGL.wrap (pkgs.writeShellScriptBin "xdg-desktop-portal-wlr" ''
    exec ${pkgs.xdg-desktop-portal-wlr}/libexec/xdg-desktop-portal-wlr "$@"
  '');
  xdpwExe = "${xdpw}/bin/xdg-desktop-portal-wlr";
in
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

  # Screen sharing: plug the Nix wlr portal backend into Ubuntu's xdg-desktop-portal.
  # XDG_DESKTOP_PORTAL_DIR replaces /usr/share/xdg-desktop-portal/portals, so the
  # system backends are linked back in alongside wlr.
  systemd.user.services.xdg-desktop-portal-wlr = {
    Unit = {
      Description = "Portal service (wlroots implementation)";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };
    Service = {
      Type = "dbus";
      BusName = "org.freedesktop.impl.portal.desktop.wlr";
      ExecStart = xdpwExe;
      Restart = "on-failure";
    };
  };

  xdg.dataFile = let
    systemPortal = name: {
      "xdg-desktop-portal/portals/${name}.portal".source =
        config.lib.file.mkOutOfStoreSymlink "/usr/share/xdg-desktop-portal/portals/${name}.portal";
    };
  in {
    "xdg-desktop-portal/portals/wlr.portal".source =
      "${pkgs.xdg-desktop-portal-wlr}/share/xdg-desktop-portal/portals/wlr.portal";
    "dbus-1/services/org.freedesktop.impl.portal.desktop.wlr.service".text = ''
      [D-BUS Service]
      Name=org.freedesktop.impl.portal.desktop.wlr
      Exec=${xdpwExe}
      SystemdService=xdg-desktop-portal-wlr.service
    '';
    # With XDG_DESKTOP_PORTAL_DIR set, xdg-desktop-portal 1.18 only reads portals.conf from that dir
    "xdg-desktop-portal/portals/sway-portals.conf".text = ''
      [preferred]
      default=gtk
      org.freedesktop.impl.portal.ScreenCast=wlr
      org.freedesktop.impl.portal.Screenshot=wlr
    '';
  } // systemPortal "gtk" // systemPortal "gnome" // systemPortal "gnome-keyring";

  xdg.configFile = {
    "systemd/user/xdg-desktop-portal.service.d/portal-dir.conf".text = ''
      [Service]
      Environment=XDG_DESKTOP_PORTAL_DIR=${config.xdg.dataHome}/xdg-desktop-portal/portals
    '';
    "xdg-desktop-portal-wlr/config".text = ''
      [screencast]
      chooser_type=dmenu
      chooser_cmd=${pkgs.wofi}/bin/wofi --dmenu --prompt 'Share' --width 1000
    '';
  };

  wayland.windowManager.sway.config = {
    workspaceOutputAssign = [
      { workspace = "1"; output = "eDP-1"; }
      { workspace = "2"; output = "eDP-1"; }
      { workspace = "3"; output = [ "DVI-I-1" "DP-4" ]; }
      { workspace = "4"; output = "eDP-1"; }
      { workspace = "5"; output = [ "DVI-I-1" "DP-4" ]; }
    ];
    output = {
      eDP-1 = {
        mode = "2880x1800@60Hz";
        scale = "1.8";
        position = "0 400";
        background = "#2F4970 solid_color";
      };
      DVI-I-1 = {
        mode = "3840x2160@59.997Hz";
        scale = "1.4";
        position = "1440 0";
        background = "#2F4970 solid_color";
      };
      DP-4 = {
        mode = "3440x1440@99.982Hz";
        position = "-1000 -1040";
        background = "#2F4970 solid_color";
      };
    };
  };

  imports = [ ../home-modules/sway.nix ];
}
