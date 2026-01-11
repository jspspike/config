{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.rustic-server;
in
{
  options.services.rustic-server = {
    enable = mkEnableOption "Rustic Backup Server";

    package = mkOption {
      type = types.package;
      default = pkgs.rustic-server; # defaults to nixpkgs version
      defaultText = literalExpression "pkgs.rustic-server";
      description = "The rustic-server package to use.";
    };

    listenAddress = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = "The IP address to listen on.";
    };

    port = mkOption {
      type = types.port;
      default = 8000;
      description = "The port to listen on.";
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/rustic";
      description = "The directory where rustic stores its data.";
    };

    aclFile = mkOption {
      type = types.path;
      description = "Path to the ACL TOML configuration file.";
    };

    htpasswdFile = mkOption {
      type = types.path;
      description = "Path to the htpasswd file containing credentials.";
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Extra arguments to pass to the rustic-server command.";
    };
  };

  config = mkIf cfg.enable {
    # Create the service
    systemd.services.rustic-server = {
      description = "Rustic Backup Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        # We construct the command using the options provided
        ExecStart = concatStringsSep " " (
          [
            "${cfg.package}/bin/rustic-server serve"
            "--listen ${cfg.listenAddress}:${toString cfg.port}"
            "--path ${cfg.dataDir}"
            "--acl-path ${cfg.aclFile}"
            "--htpasswd-file ${cfg.htpasswdFile}"
            "--private-repos"
          ] ++ cfg.extraArgs
        );

        Restart = "always";
        User = "rustic";
        Group = "rustic";

        # Security & Sandboxing
        # If the dataDir is the default, StateDirectory handles creation/permissions.
        # If it's custom, we assume the user manages the path or we need ReadWritePaths.
        StateDirectory = mkIf (lib.hasPrefix "/var/lib/" cfg.dataDir) (lib.removePrefix "/var/lib/" cfg.dataDir);
        # 2. If it's a custom path (like /mnt/storage), we must explicitly open the sandbox
        ReadWritePaths = mkIf (!lib.hasPrefix "/var/lib/" cfg.dataDir) [ cfg.dataDir ];

        ProtectSystem = "full";
        NoNewPrivileges = true;
        PrivateTmp = true;
      };
    };

    # Define the user
    users.users.rustic = {
      isSystemUser = true;
      group = "rustic";
      description = "Rustic Backup Server User";
    };

    # Define the group
    users.groups.rustic = {};
  };
}
