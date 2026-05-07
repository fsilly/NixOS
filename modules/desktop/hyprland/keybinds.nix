{
  host,
  lib,
  pkgs,
  inputs,
  ...
}: 
let
  inherit (lib) getExe getExe';
  inherit (import ../../../hosts/${host}/variables.nix)
    bar
    waybarTheme
    browser
    terminal
    fileManager
    kbdLayout
    kbdVariant
    defaultWallpaper
    wsSwitchTimeOffset
    ;

  # Import script modules
  # autowaybar = pkgs.callPackage ./scripts/autowaybar.nix { };
  autoclicker = pkgs.callPackage ./scripts/autoclicker.nix { };
  batterynotify = pkgs.callPackage ./scripts/batterynotify.nix { };
  clipmanager = pkgs.callPackage ./scripts/clipmanager.nix { };
  fileManagerScript = pkgs.callPackage ./scripts/file-manager.nix { inherit terminal; };
  gamemode = pkgs.callPackage ./scripts/gamemode.nix { };
  keyboardswitch = pkgs.callPackage ./scripts/keyboardswitch.nix { };
  keybinds-yad = pkgs.callPackage ./scripts/keybinds-yad.nix { };
  # keybinds-rofi = pkgs.callPackage ./scripts/keybinds-yad.nix { };
  # mediactrl = pkgs.callPackage ./scripts/mediactrl.nix { };
  rofimusic = pkgs.callPackage ./scripts/rofimusic.nix { };
  screen-record = pkgs.callPackage ./scripts/screen-record.nix { };
  screenshot = pkgs.callPackage ./scripts/screenshot.nix { };
  wallpaper = pkgs.callPackage ./scripts/wallpaper.nix { inherit defaultWallpaper; };
  zoom = pkgs.callPackage ./scripts/zoom.nix { };
in
{
    binde = [
      # Resize windows
      "$mainMod SHIFT, right, resizeactive, 30 0"
      "$mainMod SHIFT, left, resizeactive, -30 0"
      "$mainMod SHIFT, up, resizeactive, 0 -30"
      "$mainMod SHIFT, down, resizeactive, 0 30"

      # Resize windows with hjkl keys
      "$mainMod SHIFT, l, resizeactive, 30 0"
      "$mainMod SHIFT, h, resizeactive, -30 0"
      "$mainMod SHIFT, k, resizeactive, 0 -30"
      "$mainMod SHIFT, j, resizeactive, 0 30"

      # Functional keybinds
      ",XF86MonBrightnessDown,exec,${pkgs.brightnessctl}/bin/brightnessctl set 2%-"
      ",XF86MonBrightnessUp,exec,${pkgs.brightnessctl}/bin/brightnessctl set +2%"
      ",XF86AudioLowerVolume,exec,${pkgs.pamixer}/bin/pamixer -d 2"
      ",XF86AudioRaiseVolume,exec,${pkgs.pamixer}/bin/pamixer -i 2"
    ];
    bindm = [
      # Move/Resize windows with mainMod + LMB/RMB and dragging
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];
    bind = [
      # Caelestia
      "$mainMod, SPACE, global, caelestia:launcher"

      # Keybinds help menu
      "$mainMod, question, exec, ${getExe keybinds-yad}"
      "$mainMod, slash, exec, ${getExe keybinds-yad}"
      #"$mainMod CTRL, K, exec, ${getExe keybinds-yad}"

      "$mainMod, TAB, exec, qs ipc -c overview call overview toggle"

      "$mainMod, F8, exec, kill $(cat /tmp/auto-clicker.pid) 2>/dev/null || ${getExe autoclicker} --cps 40"
      # "$mainMod ALT, mouse:276, exec, kill $(cat /tmp/auto-clicker.pid) 2>/dev/null || ${lib.getExe autoclicker} --cps 60"

      # Night Mode (lower value means warmer temp)
      "$mainMod, F9, exec, ${getExe pkgs.hyprsunset} --temperature 2500" # good values: 3500, 3000, 2500
      "$mainMod, F10, exec, pkill hyprsunset"

      # Window/Session actions
      "$mainMod, Q, killactive"
      "ALT, F4, forcekillactive"
      "$mainMod, delete, exit" # kill hyperland session
      "$mainMod, W, togglefloating" # toggle the window on focus to float
      "$mainMod SHIFT, G, togglegroup" # toggle the window on focus to float
      "ALT, return, fullscreen" # toggle the window on focus to fullscreen
      "$mainMod ALT, L, exec, hyprlock" # lock screen
      "$mainMod, backspace, exec, pkill -x wlogout || wlogout -b 4" # logout menu
      "$CONTROL, ESCAPE, exec, pkill waybar || pkill hyprpanel || ${bar}" # toggle bar
      "$mainMod CTRL, mouse_down, exec, ${getExe zoom} in" # zoom in
      "$mainMod CTRL, mouse_up, exec, ${getExe zoom} out" # zoom out

      # Applications/Programs
      "$mainMod, Return, exec, $term"
      "$mainMod, T, exec, $term"
      "$mainMod, E, exec, ${getExe fileManagerScript} ${fileManager}"
      "$mainMod, C, exec, $editor"
    "$mainMod, F, exec, vimb duckduckgo.com"
      "$mainMod SHIFT, S, exec, spotify"
      "$mainMod SHIFT, Y, exec, youtube-music"
      "$CONTROL ALT, DELETE, exec, $term -e '${getExe pkgs.btop}'" # System Monitor
      "$CONTROL ALT, M, exec, $term --class \"microfetch\" --hold -e microfetch" # System Monitor
      "$mainMod CTRL, C, exec, ${getExe pkgs.hyprpicker} --autocopy --format=hex" # Colour Picker

      "$mainMod, A, exec, launcher drun" # launch desktop applications
      #"$mainMod, SPACE, exec, launcher drun" # launch desktop applications
      "$mainMod SHIFT, W, exec, launcher wallpaper" # launch wallpaper switcher
      "$mainMod, Z, exec, launcher emoji" # launch emoji picker
      "$mainMod SHIFT, T, exec, launcher tmux" # launch tmux sessions
      "$mainMod, G, exec, launcher games" # game launcher
      # "$mainMod, tab, exec, launcher window" # switch between desktop applications
      # "$mainMod, R, exec, launcher file" # brrwse system files
      "$mainMod ALT, K, exec, ${getExe keyboardswitch}" # change keyboard layout
      "$mainMod SHIFT, N, exec, swaync-client -t -sw" # swayNC panel
      "$mainMod SHIFT, Q, exec, swaync-client -t -sw" # swayNC panel
      "$mainMod ALT, G, exec, ${getExe gamemode}" # disable hypr effects for gamemode
      "$mainMod, V, exec, ${getExe clipmanager}" # Clipboard Manager
      "$mainMod, M, exec, ${getExe rofimusic}" # online music

      # Screenshot/Screencapture
      "$mainMod SHIFT, R, exec, ${getExe screen-record} a" # Screen Record (area select)
      "$mainMod CTRL, R, exec, ${getExe screen-record} m" # Screen Record (monitor select)
      "$mainMod, P, exec, ${getExe screenshot} s" # drag to snip an area / click on a window to print it
      "$mainMod CTRL, P, exec, ${getExe screenshot} sf" # frozen screen, drag to snip an area / click on a window to print it
      "$mainMod, print, exec, ${getExe screenshot} m" # print focused monitor
      "$mainMod ALT, P, exec, ${getExe screenshot} p" # print all monitor outputs

      # Functional keybinds
      ",xf86Sleep, exec, systemctl suspend" # Put computer into sleep mode
      ",XF86AudioMicMute,exec,${pkgs.pamixer}/bin/pamixer --default-source -t" # mute mic
      ",XF86AudioMute,exec,${pkgs.pamixer}/bin/pamixer -t" # mute audio
      ",XF86AudioPlay,exec,${pkgs.playerctl}/bin/playerctl play-pause" # Play/Pause media
      ",XF86AudioPause,exec,${pkgs.playerctl}/bin/playerctl play-pause" # Play/Pause media
      ",xf86AudioNext,exec,${pkgs.playerctl}/bin/playerctl next" # go to next media
      ",xf86AudioPrev,exec,${pkgs.playerctl}/bin/playerctl previous" # go to previous media

      # ",xf86AudioNext,exec,${getExe mediactrl} next" # go to next media
      # ",xf86AudioPrev,exec,${getExe mediactrl} previous" # go to previous media
      # ",XF86AudioPlay,exec,${getExe mediactrl} play-pause" # go to next media
      # ",XF86AudioPause,exec,${getExe mediactrl} play-pause" # go to next media

      # to switch between windows in a floating workspace
      #"$mainMod, Tab, cyclenext"
      #"$mainMod, Tab, bringactivetotop"

      # Switch workspaces relative to the active workspace with mainMod + CTRL + [←→]
      #"$mainMod CTRL, right, workspace, r+1"
      #"$mainMod CTRL, left, workspace, r-1"
    #              "$mainMod CTRL, L, workspace, r+1"
    #              "$mainMod CTRL, H, workspace, r-1"
    # Move to a workspace


      # move to the first empty workspace instantly with mainMod + CTRL + [↓]
      #"$mainMod CTRL, down, workspace, empty"

      # Move focus with mainMod + arrow keys
      #"$mainMod, left, movefocus, l"
      #"$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"
      #"ALT, Tab, movefocus, d"

      # Move focus with mainMod + HJKL keys
      "$mainMod, h, movefocus, l"
      "$mainMod, l, movefocus, r"
      "$mainMod, k, movefocus, u"
      "$mainMod, j, movefocus, d"

      # Switch scrolling columns
      "$mainMod, period, layoutmsg, move +col"
      "$mainMod, comma, layoutmsg, move -col"

      # Go to workspace 5, 6 and 7 with mouse side buttons
      "$mainMod, mouse:276, workspace, 5"
      "$mainMod, mouse:275, workspace, 6"
      "$mainMod ALT, mouse:275, workspace, 7"
      "$mainMod SHIFT, mouse:276, movetoworkspace, 5"
      "$mainMod SHIFT, mouse:275, movetoworkspace, 6"
      "$mainMod SHIFT ALT, mouse:275, movetoworkspace, 7"
      "$mainMod CTRL, mouse:276, movetoworkspacesilent, 5"
      "$mainMod CTRL, mouse:275, movetoworkspacesilent, 6"
      "$mainMod CTRL ALT, mouse:275, movetoworkspacesilent, 7"

      # Rebuild NixOS with a KeyBind
      "$mainMod, U, exec, $term -e rebuild"

      # Scroll through existing workspaces with mainMod + scroll
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"

      # Move active window to a relative workspace with mainMod + CTRL + ALT + [←→]
      "$mainMod CTRL ALT, right, movetoworkspace, r+1"
      "$mainMod CTRL ALT, left, movetoworkspace, r-1"

      # Move active window around current workspace with mainMod + SHIFT + CTRL [←→↑↓]
      "$mainMod SHIFT $CONTROL, left, movewindow, l"
      "$mainMod SHIFT $CONTROL, right, movewindow, r"
      "$mainMod SHIFT $CONTROL, up, movewindow, u"
      "$mainMod SHIFT $CONTROL, down, movewindow, d"

      # Move active window around current workspace with mainMod + SHIFT + CTRL [HLJK]
      "$mainMod SHIFT $CONTROL, H, movewindow, l"
      "$mainMod SHIFT $CONTROL, L, movewindow, r"
      "$mainMod SHIFT $CONTROL, K, movewindow, u"
      "$mainMod SHIFT $CONTROL, J, movewindow, d"

      # Special workspaces (scratchpad)
      "$mainMod CTRL, S, movetoworkspacesilent, special"
      "$mainMod ALT, S, movetoworkspacesilent, special"
      "$mainMod, S, togglespecialworkspace,"




      # ---- HYPRKOOL ----
      # Switch activity
      "$mainMod, N, exec, hyprkool next-activity -c"

      # Move active window to a different acitvity
      "$mainMod CTRL, N, exec, hyprkool next-activity -c -w"

      # Switch monitor
      #"$mainMod, code:49, exec, $hyprkool next-monitor -c"

      # Move active window to a different monitor
      #"$mainMod CTRL, code:49, exec, $hyprkool next-monitor -c -w"

      # Swap active workspaces on current and next monitor
      #"$mainMod SHIFT, code:49, exec, $hyprkool swap-monitors-active-workspace"
      #"$mainMod CTRL SHIFT, code:49, exec, $hyprkool swap-monitors-active-workspace -w"

      # Relative workspace jumps
      "$mainMod CTRL, h, exec,  qs ipc -c overview call overview quickShow && sleep ${wsSwitchTimeOffset} &&  hyprkool move-left -c "
      "$mainMod CTRL, l, exec,  qs ipc -c overview call overview quickShow && sleep ${wsSwitchTimeOffset} &&  hyprkool move-right -c "
      "$mainMod CTRL, j, exec,  qs ipc -c overview call overview quickShow && sleep ${wsSwitchTimeOffset} &&  hyprkool move-down -c "
      "$mainMod CTRL, k, exec,  qs ipc -c overview call overview quickShow && sleep ${wsSwitchTimeOffset} &&  hyprkool move-up -c "
      "$mainMod CTRL, left, exec,  qs ipc -c overview call overview quickShow && sleep ${wsSwitchTimeOffset} &&  hyprkool move-left -c "
      "$mainMod CTRL, right, exec,  qs ipc -c overview call overview quickShow && sleep ${wsSwitchTimeOffset} &&  hyprkool move-right -c "
      "$mainMod CTRL, down, exec,  qs ipc -c overview call overview quickShow && sleep ${wsSwitchTimeOffset} &&  hyprkool move-down -c "
      "$mainMod CTRL, up, exec,  qs ipc -c overview call overview quickShow && sleep ${wsSwitchTimeOffset} &&  hyprkool move-up -c "

      # Move active window to a workspace
      "$mainMod ALT CTRL, h, exec, hyprkool move-left -c -w"
      "$mainMod ALT CTRL, l, exec, hyprkool move-right -c -w"
      "$mainMod ALT CTRL, j, exec, hyprkool move-down -c -w"
      "$mainMod ALT CTRL, k, exec, hyprkool move-up -c -w"

      # toggle special workspace
      #"$mainMod, SPACE, exec, hyprkool toggle-special-workspace -n minimized"
      # move active window to special workspace without switching to that workspace
      #"$mainMod, s, exec, hyprkool toggle-special-workspace -n minimized -w -s"

      # harpoon for workspaces (previously known as named-focus :P)
      # switch to named focus
     "$mainMod, 1, exec, hyprkool switch-named-focus -n 1"
     "$mainMod, 2, exec, hyprkool switch-named-focus -n 2"
     "$mainMod, 3, exec, hyprkool switch-named-focus -n 3"
      # set / delete named focus
     "$mainMod SHIFT, 1, exec, hyprkool set-named-focus -n 1"
     "$mainMod SHIFT, 2, exec, hyprkool set-named-focus -n 2"
     "$mainMod SHIFT, 3, exec, hyprkool set-named-focus -n 3"
    ]
    ++ (builtins.concatLists (
      builtins.genList (
        x:
        let
          ws =
            let
              c = (x + 1) / 10;
            in
            builtins.toString (x + 1 - (c * 10));
        in
        [
          "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
          "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
          "$mainMod CTRL, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
        ]
      ) 10
    ));
    gesture = [
      "3, right, dispatcher, exec, qs ipc -c overview call overview quickShow && sleep ${wsSwitchTimeOffset} && hyprkool move-left -c"
      "3, left, dispatcher, exec, qs ipc -c overview call overview quickShow && sleep ${wsSwitchTimeOffset} && hyprkool move-right -c"
      "3, down, dispatcher, exec, qs ipc -c overview call overview quickShow && sleep ${wsSwitchTimeOffset} && hyprkool move-up -c"
      "3, up, dispatcher, exec, qs ipc -c overview call overview quickShow && sleep ${wsSwitchTimeOffset} && hyprkool move-down -c"
      #''3, left, function() os.execute("qs ipc -c overview call overview quickShow && sleep ${wsSwitchTimeOffset} && hyprkool move-left -c") end''
      #''3, right, function() os.execute("qs ipc -c overview call overview quickShow && sleep ${wsSwitchTimeOffset} && hyprkool move-right -c") end''
      #''3, up, function() os.execute("qs ipc -c overview call overview quickShow && sleep ${wsSwitchTimeOffset} && hyprkool move-up -c") end''
      #''3, down, function() os.execute("qs ipc -c overview call overview quickShow && sleep ${wsSwitchTimeOffset} && hyprkool move-down -c") end''
      #{
      #  fingers = 3;
      #  direction = "left";
      #  action = ''function()
      #      os.execute("qs ipc -c overview call overview quickShow && sleep ${wsSwitchTimeOffset} && hyprkool move-left -c")
      #  end'';
      #}
      #"3, left, sendshortcut, $mainMod, CTRL, h"
      #"3, right, sendshortcut, $mainMod, CTRL, l"
      #"3, up, sendshortcut, $mainMod, CTRL, k"
      #"3, down, sendshortcut, $mainMod, CTRL, j"
    ];
}
