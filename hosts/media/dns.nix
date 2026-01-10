{ ... }:

{
  services.dnsmasq = {
    enable = true;

    settings = {
      listen-address = ["192.168.0.117" "127.0.0.1"];

      server = ["1.1.1.1"];

      address = [
        "/home.weewoo.dev/192.168.0.117"
        "/photos.weewoo.dev/192.168.0.117"
        "/desktop.weewoo.dev/192.168.0.58"
      ];

      no-resolv = true;
      resolv-file = "/etc/dnsmasq-resolv.conf";

      log-queries = true;
      log-facility= "/var/log/dnsmasq.log";
    };
  };
}
