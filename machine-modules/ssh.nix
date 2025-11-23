{ inputs, ... }:
{
  services.openssh = {
    enable = true;
    allowSFTP = true;
    ports = [ 2222 ];
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  users.users.jspspike.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtVtM+mU2f+TVHYfgCnS6BGLa+AnTOenriWcrNAgBv3 jspspike@gmail.com" # laptop
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJI7PjE1fNRCW2jQacMFiaIDDrjLgYNV4NAWToedNQOz jspspike@gmail.com" # desktop
  ];
}
