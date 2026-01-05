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

  services.nginx.virtualHosts = {
    "photos.weewoo.dev" = {
      # Serve HTTP (port 80)
      listen = [ { addr = "0.0.0.0"; port = 80; } ];

      # Reverse proxy settings
      locations."/" = {
        proxyPass = "http://localhost:2283";
      };
      extraConfig = ''
        client_max_body_size 0;
        proxy_request_buffering off;
      '';
    };
  };
}
