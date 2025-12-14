{ ... }:

{
  services.dnsmasq = {
    enable = true;

    settings = {
      listen-address = ["192.168.1.117" "127.0.0.1"];

      server = ["1.1.1.1"];

      address = "/home.weewoo.dev/192.168.1.117";

      no-resolv = true;
      resolv-file = "/etc/dnsmasq-resolv.conf";

      #bind-interfaces = true;
      #interface = ["lo" "wlp5s0"];

      log-queries = true;
      log-facility= "/var/log/dnsmasq.log";
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };
}
