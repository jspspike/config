
{ config, pkgs, inputs, ... }:

{
  systemd = {
    services.cf-ddns = {
      description = "Update CF DNS IP";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash ${./ddns.sh}";
        StandardOutput = "journal";
      };
      environment = {
        CF_API_TOKEN_PATH= config.age.secrets.cloudflare-token.path;
      };
      path = with pkgs; [ curl jq ];
    };

    timers.cf-ddns = {
      description = "Update CF DNS IP daily";
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
      wantedBy = [ "timers.target" ];
    };
  };
}
