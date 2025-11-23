{ config, pkgs, lib, ... }:
{
  services.xserver.enable = false;

  # enable Sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  environment.variables = {
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1"; # prevents cursor corruption
  };
  services.getty = {
    autologinUser = "jspspike";
    autologinOnce = true;
  };
  systemd.services."getty@tty1" = {
    overrideStrategy = "asDropin";
    serviceConfig.ExecStart = ["" "-${pkgs.util-linux}/sbin/agetty --noreset --noclear --autologin jspspike - \$\{TERM\}"];
  };
}
