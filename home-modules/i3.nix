{ pkgs, lib, inputs, config, ... }:
{
  home.packages = with pkgs; [ dmenu xsel font-awesome ];
  xsession.windowManager.i3 = {
    enable = true;

    config = let modifier = "Mod4"; mode_system = "(s)uspend, (h)ibernate, (r)eboot, (Shift+s)hutdown"; in {
      modifier = modifier;
      focus.followMouse = false;
      defaultWorkspace = "workspace number 1";

      window = {
        border = 2;
        titlebar = false;
        commands = [{
          command = "floating enable";
          criteria = {
            class = "Pavucontrol";
          };
        }];
      };

      floating = {
        border = 2;
        titlebar = false;
        modifier = modifier;
      };
      workspaceAutoBackAndForth = true;

      fonts = {
        names = ["xft:URWGothic-Book"];
        size = 9.0;
      };

      keybindings = let workspaces = [1 2 3 4 5 6 7 8]; in {
        "${modifier}+Return" = "exec kitty";

        "${modifier}+Shift+q" = "kill";

        "${modifier}+d" = "exec --no-startup-id dmenu_run";

        "XF86AudioPlay" = "exec --no-startup-id dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause";
        "XF86AudioPrev" = "exec --no-startup-id dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous";
        "XF86AudioNext" = "exec --no-startup-id dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next";

        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";

        "${modifier}+Left" = "focus left";
        "${modifier}+Down" = "focus down";
        "${modifier}+Up" = "focus up";
        "${modifier}+Right" = "focus right";

        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";

        "${modifier}+Shift+Left" = "move left";
        "${modifier}+Shift+Down" = "move down";
        "${modifier}+Shift+Up" = "move up";
        "${modifier}+Shift+Right" = "move right";

        "${modifier}+b" = "workspace back_and_forth";

        "${modifier}+minus" = "split h";
        "${modifier}+backslash" = "split v";
        "${modifier}+q" = "split toggle";

        "${modifier}+f" = "fullscreen toggle";

        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";
        "${modifier}+a" = "focus parent";

        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+space" = "focus mode_toggle";

        "${modifier}+Shift+s" = "sticky toggle";

        "${modifier}+0" = "mode \"${mode_system}\"";
      }
      # we need a formatter
      // builtins.listToAttrs ( map ( num:
        let workspace_num = builtins.toString num; in
          { name = "${modifier}+${workspace_num}"; value = "workspace ${workspace_num}"; }
      ) workspaces )
      // builtins.listToAttrs ( map ( num:
        let workspace_num = builtins.toString num; in
          { name = "${modifier}+Ctrl+${workspace_num}"; value = "move container to workspace ${workspace_num}"; }
      ) workspaces )
      // builtins.listToAttrs ( map ( num:
        let workspace_num = builtins.toString num; in
          { name = "${modifier}+Shift+${workspace_num}"; value = "move container to workspace ${workspace_num}; workspace ${workspace_num}"; }
      ) workspaces );

      modes = {
        "${mode_system}" = {
          s = "exec --no-startup-id systemctl suspend, mode \"default\"";
          h = "exec --no-startup-id systemctl hibernate, mode \"default\"";
          r = "exec --no-startup-id reboot now, mode \"default\"";
          "Shift+s" = "exec --no-startup-id shutdown now, mode \"default\"";

          Return = "mode \"default\"";
          Escape = "mode \"default\"";
        };

        "resize" = {
          j = "resize shrink width 5 px or 5 ppt";
          k = "resize grow height 5 px or 5 ppt";
          l = "resize shrink height 5 px or 5 ppt";
          semicolon = "resize grow width 5 px or 5 ppt";

          Left = "resize shrink width 10 px or 10 ppt";
          Down = "resize grow height 10 px or 10 ppt";
          Up = "resize shrink height 10 px or 10 ppt";
          Right = "resize grow width 10 px or 10 ppt";

          Return = "mode \"default\"";
          Escape = "mode \"default\"";
        };
      };

      bars = [{
        command = "i3bar";
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
    };
  };

  programs = {
    i3status-rust = {
      enable = true;
      bars.primary = {
        theme = "slick";
        icons = "awesome6";
        blocks = [
          {
            block = "cpu";
            format = " $icon $utilization ";
          }
          {
            block = "disk_space";
            format = " $icon $free ";
          }
          {
            block = "net";
            format = " $icon $ip ";
          }
          {
            block = "memory";
            format = " $icon $mem_avail ";
          }
          {
            block = "backlight";
            invert_icons = true;
          }
          {
            block = "battery";
            full_format = " $icon $percentage ";
            missing_format = "";
          }
          {
            block = "time";
          }
        ];
      };
    };
  };
}
