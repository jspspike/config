{ config, pkgs, ... }:

let
  # Create a directory containing 'myprofile.toml'
  rusticConfigDir = pkgs.runCommand "rustic-config" {} ''
    mkdir -p $out
    cp ${./rustic.toml} $out/myprofile.toml
  '';
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
      EnvironmentFile = "${config.age.secrets.rustic-env-var.path}";
      ExecStart = "${pkgs.rustic}/bin/rustic backup -P  ${rusticConfigDir}/myprofile --password \"\"";

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
