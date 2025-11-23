{ config, pkgs, inputs, lib, ... }:

{ imports = [ ./hardware-configuration.nix ../../machine-modules/i3.nix ../../machine-modules/common.nix ../../machine-modules/ssh.nix ]; environment.extraInit = ''
    autorandr --change
    xset s off -dpms
  '';

  programs = {
    steam.enable = true;
  };

  users.users.jspspike.packages = with pkgs; [ discord spotify inputs.pineapple.packages.x86_64-linux.android-messages ];

  services = {
    libinput = {
      mouse = {
        accelProfile = "flat";
      };
    };
  };
  xsession.windowManager.i3.config.bars = [{
    command = "i3bar";
    mode = "hide";
    statusCommand = "i3status-rs ~/.config/i3status-rust/config-primary.toml";
    position = "bottom";
    trayOutput = "primary";
    colors = {
      background = "#222D31";
      statusline = "#F9FAF9";
      separator = "#454947";

      focusedWorkspace = {
        border = "#F9FAF9";
        background = "#16a085";
        text = "#292F34";
      };
      activeWorkspace = {
        border = "#595B5B";
        background = "#353836";
        text = "#FDF6E3";
      };
      inactiveWorkspace = {
        border = "#595B5B";
        background = "#222D31";
        text = "#EEE8D5";
      };
      bindingMode = {
        border = "#16a085";
        background = "#2C2C2C";
        text = "#F9FAF9";
      };
      urgentWorkspace = {
        border = "#16a085";
        background = "#FDF6E3";
        text = "#E5201D";
      };
    };
  }];
}
