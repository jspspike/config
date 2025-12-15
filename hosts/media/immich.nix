{ config, ... }:

{
  services = {
    immich = {
      enable = true;
      port = 2283;
    };

    cloudflared = {
      enable = true;
      tunnels = {
        "62f95fb0-1adc-4acc-9339-fec7d6b0890a" = {
          credentialsFile = "/home/jspspike/.cloudflared/62f95fb0-1adc-4acc-9339-fec7d6b0890a.json";
          default = "http_status:404";
        };
      };
    };
  };
}
