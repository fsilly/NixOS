{ host, ... }:
let
  inherit (import ../../../../../hosts/${host}/variables.nix) hyprlockWallpaper;
  pfp = ../../../../../assets/shush.png;

in
{
  home-manager.sharedModules = [
    (_: {
      programs.hyprlock = {
        enable = true;
        settings = {
          general = {
            hide_cursor = true;
            no_fade_in = false;
            grace = 0;
            disable_loading_bar = false;
          };

          background = [
            {
              monitor = "";
              color = "rgb(36, 39, 58)";
              path = "${../../../../themes/wallpapers/${hyprlockWallpaper}}";

              new_optimizations = true;
              blur_size = 3;
              blur_passes = 2;
              noise = 0.0117;
              contrast = 1.000;
              brightness = 1.0000;
              vibrancy = 0.2100;
              vibrancy_darkness = 0.0;
            }
          ];


          image = [
            {
              monitor = "";
              path = "${pfp}";
              size = 150;
              position = "0, 0";
              halign = "center";
              valign = "center";
              rounding = -1;
              border_size = 3;
              border_color = "rgb(198,160,246)";
            }
          ];

          input-field = [
            {
              monitor = "";
              size = "250, 50";
              outline_thickness = 3;
              outer_color = "rgb(198, 160, 246)";
              inner_color = "rgb(36, 39, 58)";
              font_color = "rgb(198, 160, 246)";
              fail_color = "rgb(237, 135, 150)";
              fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
              fail_transition = 300;
              fade_on_empty = false;
              placeholder_text = "Password...";
              dots_size = 0.2;
              dots_spacing = 0.64;
              dots_center = true;
              position = "0, 140";
              halign = "center";
              valign = "bottom";
            }
          ];
          label = [
            # TIME
            {
              monitor = "";
              text = "$TIME";
              color = "rgb(198, 160, 246)";
              font_size = 90;
              font_family = "JetBrainsMono Nerd Font";
              position = "-30, 0";
              halign = "right";
              valign = "top";
            }

            # DATE
            {
              monitor = "";
              text = "cmd[update:43200000] date +\"%A, %d %B %Y\"";
              color = "rgb(166, 173, 200)";
              font_size = 25;
              font_family = "JetBrainsMono Nerd Font";
              position = "-30, -150";
              halign = "right";
              valign = "top";
            }

            # GREETING
            {
              monitor = "";
              text = "cmd[update:60000] echo \"Good $(date +%H | awk '{if ($1 < 12) print \\\"Morning\\\"; else if ($1 < 18) print \\\"Afternoon\\\"; else print \\\"Evening\\\"}') $USER\"";
              color = "rgb(198, 160, 246)";
              font_size = 20;
              font_family = "JetBrainsMono Nerd Font Bold";
              position = "0, -16%";
              halign = "center";
              valign = "center";
            }

            # SONG / SPLASH
            {
              monitor = "";
              text = "cmd[update:1000] $SPLASH_CMD";
              color = "rgb(166, 173, 200)";
              font_size = 15;
              font_family = "JetBrainsMono Nerd Font";
              position = "0, 0";
              halign = "center";
              valign = "bottom";
            }

            # NEXT BUTTON
            {
              monitor = "";
              text = "cmd[update:1000] playerctl status 2>/dev/null | grep -q Playing && echo \"󰒭\"";
              onclick = "playerctl next";
              color = "rgb(198,160,246)";
              font_size = 20;
              font_family = "JetBrainsMono Nerd Font Bold";
              position = "2%, -13%";
              halign = "center";
              valign = "center";
            }

            # PREVIOUS BUTTON
            {
              monitor = "";
              text = "cmd[update:1000] playerctl status 2>/dev/null | grep -q Playing && echo \"󰒮\"";
              onclick = "playerctl previous";
              color = "rgb(198,160,246)";
              font_size = 20;
              font_family = "JetBrainsMono Nerd Font Bold";
              position = "-2%, -13%";
              halign = "center";
              valign = "center";
            }

            # PLAY / PAUSE
            {
              monitor = "";
              text = "cmd[update:1000] playerctl status 2>/dev/null | grep -q Playing && echo \"⏸\" || echo \"▶\"";
              onclick = "playerctl play-pause";
              color = "rgb(198,160,246)";
              font_size = 20;
              font_family = "JetBrainsMono Nerd Font Bold";
              position = "0, -13%";
              halign = "center";
              valign = "center";
            }

            # BATTERY
            {
              monitor = "";
              text = "cmd[update:5000] $BATTERY_ICON";
              color = "rgb(166, 173, 200)";
              font_size = 20;
              font_family = "JetBrainsMono Nerd Font";
              position = "-1%, 1%";
              halign = "right";
              valign = "bottom";
            }

            # KEYBOARD LAYOUT
            {
              monitor = "";
              text = "$LAYOUT";
              color = "rgb(166, 173, 200)";
              font_size = 20;
              font_family = "JetBrainsMono Nerd Font";
              position = "-2%, 1%";
              halign = "right";
              valign = "bottom";
            }
          ];

            #          label = [
            #            {
            #              monitor = "";
            #              # text = "cmd[update:1000] echo \"<b><big> $(date +\"%H:%M:%S\") </big></b>\"";
            #              text = "$TIME";
            #              font_size = 64;
            #              color = "rgb(198, 160, 246)";
            #              position = "0, 16";
            #              valign = "center";
            #              halign = "center";
            #            }
            #            {
            #              monitor = "";
            #              text = "Hello <span text_transform=\"capitalize\" size=\"larger\">$USER!</span>";
            #              color = "rgb(198, 160, 246)";
            #              font_size = 20;
            #              position = "0, 100";
            #              halign = "center";
            #              valign = "center";
            #            }
            #            {
            #              monitor = "";
            #              text = "Current Layout : $LAYOUT";
            #              color = "rgb(198, 160, 246)";
            #              font_size = 14;
            #              position = "0, 20";
            #              halign = "center";
            #              valign = "bottom";
            #            }
            #            /*
            #                 {
            #                monitor = "";
            #                text = "Enter your password to unlock.";
            #                color = "rgb(198, 160, 246)";
            #                font_size = 14;
            #                position = "0, 60";
            #                halign = "center";
            #                valign = "bottom";
            #              }
            #            */
            #          ];
        };
      };
    })
  ];
}
