{ config, pkgs, lib, ... }:

let
  getProfileName = path: lib.removeSuffix ".toml" (toString path);
in
{
  systemd.services.rustic-backup = {
    description = "Periodic Rustic backup";

    # Ensure the service only starts if the network is up
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "oneshot";
      User = "root";
      Group = "immich";

      # Security Hardening
      PrivateTmp = true;
      ProtectSystem = "full";
    };

    script = ''
      set +e

      ${pkgs.rustic}/bin/rustic backup -P ${getProfileName config.age.secrets.rustic-david-conf.path}
      s1=$?

      ${pkgs.rustic}/bin/rustic backup -P ${getProfileName config.age.secrets.rustic-desktop-conf.path}
      s2=$?

      if [ "$s1" -ne 0 ] || [ "$s2" -ne 0 ]; then
        echo "rustic backup failed: david=$s1 desktop=$s2" >&2
        exit 1
      fi
    '';
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
