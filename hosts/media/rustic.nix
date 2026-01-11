{ config, pkgs, lib, ... }:

let
  getProfileName = path: lib.removeSuffix ".toml" (toString path);
in
{
  systemd.services.rustic-backup = {
    description = "Periodic Rustic backupta";

    # Ensure the service only starts if the network is up
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "oneshot";
      User = "root";
      Group = "immich";
      ExecStart = "${pkgs.rustic}/bin/rustic backup -P  ${getProfileName config.age.secrets.rustic-desktop-conf.path}";

      # Security Hardening
      PrivateTmp = true;
      ProtectSystem = "full";
    };
  };

  # 2. Define the Timer
  systemd.timers.rustic-backup = {
    description = "Timer for Rustic backup";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      Unit = "rustic-backup.service";
    };
  };
}
