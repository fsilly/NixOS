{ pkgs, ... }:

{
  home-manager.sharedModules = [
{
  programs.ghostty = {
    enable = true;
        settings = {
          font-family = "JetBrainsMono Nerd Font";
          font-family-bold = true;
          font-size = 16;

          background = "#1a0920";
          foreground = "#ebdcf1";
          cursor-color = "#F5C2E7";
          selection-background = "#7b80d1";
          selection-foreground = "#501d41";

          window-padding-x = 10;
          window-padding-y = 10;

          #clipboard-copy-on-select = true;
          quit-after-last-window-closed = true;

          scrollback-limit = 10000;

          shell-integration = "detect";

          # macOS
          macos-option-as-alt = true;

          palette = [
            "0=#353434"
            "1=#b96cff"
            "2=#ffbac2"
            "3=#ffdcf2"
            "4=#9da8d8"
            "5=#bb9de8"
            "6=#9dceff"
            "7=#e8d3de"
            "8=#ac9fa9"
            "9=#cb8fff"
            "10=#ffd2d5"
            "11=#fff0f6"
            "12=#b7c0dd"
            "13=#cfb3f2"
            "14=#bae0ff"
            "15=#ffffff"
          ];
        };
      };

      xdg.configFile."ghostty/config".text = ''
        keybind = ctrl+t=new_split:right
        keybind = ctrl+y=paste_from_clipboard

        # Launch sessionizer
        keybind = ctrl+alt+t=text:tmux-sessionizer

        # Tab navigation
        keybind = alt+1=goto_tab:1
        keybind = alt+2=goto_tab:2
        keybind = alt+3=goto_tab:3
        keybind = alt+4=goto_tab:4
        keybind = alt+5=goto_tab:5
        keybind = alt+6=goto_tab:6
        keybind = alt+7=goto_tab:7
        keybind = alt+8=goto_tab:8
        keybind = alt+9=goto_tab:9
      '';
    }
  ];
}
