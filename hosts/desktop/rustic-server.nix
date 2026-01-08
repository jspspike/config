{ config, self, ... }:
{
  systemd.services.rustic-server = {
    description = "Rustic Backup Server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${self.packages.x86_64-linux.rustic-server}/bin/rustic-server serve --acl-path ${./acl.toml} --htpasswd-file ${config.age.secrets.rustic-htpasswd.path} --private-repos --listen 0.0.0.0:8000 --path \"/var/lib/rustic/backup\" ";

      Restart = "always";
      User = "rustic";
      Group = "rustic";

      # Security Sandboxing
      StateDirectory = "rustic";
      ProtectSystem = "full";
      NoNewPrivileges = true;
      PrivateTmp = true;
    };
  };

  # Define the user if it doesn't exist
  users.users.rustic = {
    isSystemUser = true;
    group = "rustic";
  };
  users.groups.rustic = {};
}
