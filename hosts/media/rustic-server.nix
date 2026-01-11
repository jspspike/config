{ config, self, ... }:
{
  services.rustic-server = {
    enable = true;

    # Optional: Override the package if you want the specific one from your flake inputs
    package = self.packages.x86_64-linux.rustic-server;

    # Configuration
    listenAddress = "0.0.0.0";
    port = 8000;
    dataDir = "/var/lib/rustic/backup";

    # File paths
    aclFile = ./acl.toml;
    htpasswdFile = config.age.secrets.rustic-media-htpasswd.path;
  };
}
