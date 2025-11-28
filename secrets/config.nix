{ config, pkgs, ... }:
{
  age = {
    identityPaths = [ "/home/jspspike/.age/keys" ];
    secrets = import ../secrets/secrets.nix;
  };
}
