{ pkgs, ... }:
{
  home-manager.sharedModules = [
    (_: {
      programs.kitty = {
        enable = true;
        font = {
          size = 12.0;
          name = "monospace";
        };
        #themeFile = "Catppuccin-Mocha";
        settings = {
          # shell = "${getExe pkgs.tmux}";
          # cursor_trail = 3; # Fancy cursor movements (especially in nixvim)
          # cursor_trail_decay = "0.08 0.3"; # Animation speed
          # cursor_trail_start_threshold = "4";
          strip_trailing_spaces = "smart";
          macos_option_as_alt = "yes";
          macos_quit_when_last_window_closed = true;
          copy_on_select = "yes";
          confirm_os_window_close = 0;
          scrollback_lines = 10000;
          enable_audio_bell = false;
          mouse_hide_wait = 60;
          update_check_interval = 0;

          ## Tabs
          tab_title_template = "{index}";
          active_tab_font_style = "normal";
          inactive_tab_font_style = "normal";
          tab_bar_style = "powerline";
          tab_powerline_style = "round";
          active_tab_foreground = "#1e1e2e";
          active_tab_background = "#cba6f7";
          inactive_tab_foreground = "#bac2de";
          inactive_tab_background = "#313244";
          window_padding_width = 10;
        };
        # shellIntegration.mode = "no-sudo";
              
        extraConfig = ''
#          # Colors (Catppuccin Mocha example)
#          foreground              #CDD6F4
#          background              #1E1E2E
#          selection_foreground    #1E1E2E
#          selection_background    #F5E0DC
#
#          color0  #45475A
#          color1  #F38BA8
#          color2  #A6E3A1
#          color3  #F9E2AF
#          color4  #89B4FA
#          color5  #F5C2E7
#          color6  #94E2D5
#          color7  #BAC2DE
#
#          color8  #585B70
#          color9  #F38BA8
#          color10 #A6E3A1
#          color11 #F9E2AF
#          color12 #89B4FA
#          color13 #F5C2E7
#          color14 #94E2D5
#          color15 #A6ADC8
# background            #101010
# foreground            #999993
# cursor                #9d9eca
# selection_background  #4d4d4d
# color0                #333333
# color8                #3d3d3d
# color1                #8c4665
# color9                #bf4d80
# color2                #287373
# color10               #53a6a6
# color3                #7c7c99
# color11               #9e9ecb
# color4                #395573
# color12               #477ab3
# color5                #5e468c
# color13               #7e62b3
# color6                #31658c
# color14               #6096bf
# color7                #899ca1
# color15               #c0c0c0
# selection_foreground #101010
#           background #212733
#           foreground #d9d7ce
#           cursor #F5C2E7
#           selection_background #343f4c
#           color0 #191e2a
#           color8 #686868
#           color1 #ed8274
#           color9 #f28779
#           color2  #a6cc70
#           color10 #bae67e
#           color3  #fad07b
#           color11 #ffd580
#           color4  #6dcbfa
#           color12 #73d0ff
#           color5  #cfbafa
#           color13 #d4bfff
#           color6  #90e1c6
#           color14 #95e6cb
#           color7  #c7c7c7
#           color15 #ffffff
#           selection_foreground #212733

# primary_paletteKeyColor #786fab
# secondary_paletteKeyColor #79748e
# tertiary_paletteKeyColor #a1638a
# neutral_paletteKeyColor #79767b
# neutral_variant_paletteKeyColor #787580
# background #1a0920
background #1a0920
# onBackground #ebdcf1
selection_foreground #ebdcf1
# surface #1a0920
# surfaceDim #1a0920
# surfaceBright #3a383d
# surfaceContainerLowest #0e0e11
# surfaceContainerLow #211326
# surfaceContainer #26182c
# surfaceContainerHigh #312036
# surfaceContainerHighest #3b2840
# onSurface #ebdcf1
# surfaceVariant #48454f
# onSurfaceVariant #c9c4d0
# inverseSurface #ebdcf1
# inverseOnSurface #313034
# outline #938f9a
# outlineVariant #48454f
# shadow #000000
# scrim #000000
# surfaceTint #c279db
# primary #bda0c8
# onPrimary #31285f
# primaryContainer #786fab
# onPrimaryContainer #ffffff
# inversePrimary #5f5791
# secondary #a77ab8
# onSecondary #312e44
# secondaryContainer #48445b
# onSecondaryContainer #b7b1ce
# tertiary #6f218b
#cursor #6f218b
cursor #F5C2E7
#cursor #ebdcf1
# onTertiary #501d41
selection_foreground #501d41
# tertiaryContainer #be7ca5
# onTertiaryContainer #000000
# error #ffb4ab
# onError #690005
# errorContainer #93000a
# onErrorContainer #ffdad6
# primaryFixed #e5deff
# primaryFixedDim #c9bfff
# onPrimaryFixed #1b1149
# onPrimaryFixedVariant #473f77
# secondaryFixed #e5dffc
# secondaryFixedDim #c9c3e0
# onSecondaryFixed #1c192e
# onSecondaryFixedVariant #48445b
# tertiaryFixed #ffd8ec
# tertiaryFixedDim #f9b1dc
# onTertiaryFixed #37072b
# onTertiaryFixedVariant #6a3458
color0 #353434
color1 #b96cff
color2 #ffbac2
color3 #ffdcf2
color4 #9da8d8
color5 #bb9de8
color6 #9dceff
color7 #e8d3de
color8 #ac9fa9
color9 #cb8fff
color10 #ffd2d5
color11 #fff0f6
color12 #b7c0dd
color13 #cfb3f2
color14 #bae0ff
color15 #ffffff
# rosewater #f8eff8
# flamingo #ebddf2
# pink #e6d6ff
# mauve #c6b6ff
# red #c9a3fa
# maroon #ceb4eb
# peach #e5c1f6
# yellow #ffecf3
# green #c8e3ff
# teal #d7dfff
# sky #d3d9ff
# sapphire #bdc3ff
# blue #b7b6ff
# lavender #ccc6ff
# klink #7b80d1
# klinkSelection #7b80d1
# kvisited #8a6fd7
# kvisitedSelection #8a6fd7
# knegative #ac62fa
# knegativeSelection #ac62fa
# kneutral #d48dff
# kneutralSelection #d48eff
# kpositive #60adff
# kpositiveSelection #60adff
# text #ebdcf1
# subtext1 #c9c4d0
# subtext0 #938f9a
# overlay2 #807c86
# overlay1 #6c6972
# overlay0 #5b5860
# surface2 #4a474e
# surface1 #39373d
# surface0 #262529
# base #1a0920
# mantle #1a0920
# crust #131216
# success #B5CCBA
# onSuccess #213528
# successContainer #374B3E
# onSuccessContainer #D1E9D6
        '';
        keybindings = {
          "ctrl+alt+n" = "launch --cwd=current";
          "alt+w" = "copy_and_clear_or_interrupt";
          "ctrl+y" = "paste_from_clipboard";
          "alt+1" = "goto_tab 1";
          "alt+2" = "goto_tab 2";
          "alt+3" = "goto_tab 3";
          "alt+4" = "goto_tab 4";
          "alt+5" = "goto_tab 5";
          "alt+6" = "goto_tab 6";
          "alt+7" = "goto_tab 7";
          "alt+8" = "goto_tab 8";
          "alt+9" = "goto_tab 9";
          "alt+0" = "goto_tab 10";

          # Tmux
          "ctrl+t" = "launch --cwd=current --type=overlay tmux-sessionizer";
          # "ctrl+t" = "launch --cwd=current --title tmux-sessionizer tmux-sessionizer";
          "ctrl+shift+left" = "no_op";
          "ctrl+shift+right" = "no_op";
        };
      };
    })
  ];
}
