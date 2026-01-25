{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.mullvad-netns;
in {
  options.services.mullvad-netns = {
    enable = mkEnableOption "Mullvad VPN Namespace";

    privateKeyFile = mkOption {
      type = types.path;
      description = "Path to the WireGuard private key file.";
    };

    addressV4 = mkOption {
      type = types.str;
      description = "IPv4 address for the interface (e.g. '10.65.x.x/32').";
    };

    addressV6 = mkOption {
      type = types.str;
      description = "IPv6 address for the interface.";
    };

    dnsIp = mkOption {
      type = types.str;
      default = "10.64.0.1";
      description = "The internal DNS IP to use.";
    };

    peerPublicKey = mkOption {
      type = types.str;
      default = "7v5alccqwh+9jA+hRqwc1uZIEebXs9g5i/jH29Gr5k0=";
      description = "The WireGuard public key of the server.";
    };

    endpoint = mkOption {
      type = types.str;
      default = "206.217.206.16:51820";
      description = "The server endpoint (IP:PORT).";
    };
  };

  config = mkIf cfg.enable {
    # 1. Declarative Config Files (DNS Fixes)
    environment.etc = {
      "netns/mullvad/nsswitch.conf".text = "hosts: files dns";
      "netns/mullvad/resolv.conf".text = "nameserver ${cfg.dnsIp}";
    };

    # 2. The Wrapper Script (Integrated into the module)
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "mv-run" ''
        exec sudo ${pkgs.iproute2}/bin/ip netns exec mullvad sudo -u "$(whoami)" "$@"
      '')
    ];

    # 3. The Service
    systemd.services.mullvad-netns = {
      description = "Mullvad WireGuard Namespace";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [ iproute2 wireguard-tools iptables ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "${pkgs.iproute2}/bin/ip netns del mullvad";
      };

      script = ''
        # Cleanup
        ip netns del mullvad 2>/dev/null || true
        ip link del wg0 2>/dev/null || true

        # Setup Namespace & Interface
        ip netns add mullvad
        ip link add wg0 type wireguard

        # Configure WireGuard
        wg set wg0 \
          private-key "${cfg.privateKeyFile}" \
          peer "${cfg.peerPublicKey}" \
          endpoint "${cfg.endpoint}" \
          allowed-ips "0.0.0.0/0,::/0"

        # Move to Namespace & Bring Up
        ip link set wg0 netns mullvad
        ip -n mullvad addr add ${cfg.addressV4} dev wg0
        ip -n mullvad -6 addr add ${cfg.addressV6} dev wg0
        ip -n mullvad link set wg0 up
        ip -n mullvad route add default dev wg0
        ip -n mullvad -6 route add default dev wg0

        # --- FIREWALL & KILLSWITCH ---
        # 1. Block IPv6 DNS
        ip netns exec mullvad ip6tables -A OUTPUT -p udp --dport 53 -j DROP
        ip netns exec mullvad ip6tables -A OUTPUT -p tcp --dport 53 -j DROP

        # 2. Allow IPv4 DNS ONLY to Mullvad
        ip netns exec mullvad iptables -A OUTPUT -p udp -d ${cfg.dnsIp} --dport 53 -j ACCEPT
        ip netns exec mullvad iptables -A OUTPUT -p tcp -d ${cfg.dnsIp} --dport 53 -j ACCEPT

        # 3. Killswitch: Block all other DNS
        ip netns exec mullvad iptables -A OUTPUT -p udp --dport 53 -j DROP
        ip netns exec mullvad iptables -A OUTPUT -p tcp --dport 53 -j DROP

        # 4. Block DoH Providers
        ip netns exec mullvad iptables -A OUTPUT -d 8.8.8.8,8.8.4.4,1.1.1.1,1.0.0.1 -j DROP

        # 5. Block QUIC
        ip netns exec mullvad iptables -A OUTPUT -p udp --dport 443 -j DROP
      '';
    };
  };
}
