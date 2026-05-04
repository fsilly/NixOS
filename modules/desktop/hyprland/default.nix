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
    ;

  # Import script modules
  # autowaybar = pkgs.callPackage ./scripts/autowaybar.nix { };
  autoclicker = pkgs.callPackage ./scripts/autoclicker.nix { };
  #batterynotify = pkgs.callPackage ./scripts/batterynotify.nix { };
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
  border-animation = pkgs.callPackage ./scripts/border-animation.nix { };
in
{
  imports = [
    ./programs/wlogout
    ./programs/rofi
    ./programs/hypridle
    ./programs/hyprlock
  ]
  ++ lib.optionals (bar == "hyprpanel") [
    ./programs/hyprpanel
    ../../themes/rose-pine # Catppuccin GTK and QT themes
  ]
  ++ lib.optionals (bar == "noctalia") [
    # ./programs/dunst
    ../../themes/rose-pine # Catppuccin GTK and QT themes
    ./programs/swaync
    ./programs/noctalia
  ]
  ++ lib.optionals (bar == "caelestia-shell") [
    ./programs/caelestia-shell
    ./programs/swaync
  ]
  ++ lib.optionals (bar == "waybar") [
    # ./programs/dunst
    ../../themes/rose-pine # Catppuccin GTK and QT themes
    ./programs/swaync
    ./programs/waybar/${waybarTheme}.nix
  ];

  environment.systemPackages = with pkgs; [
    pavucontrol
    swappy
    cliphist
    wl-clipboard
  ];

  systemd.user.services.hyprpolkitagent = {
    description = "Hyprpolkitagent - Polkit authentication agent";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
  services.displayManager.defaultSession = "hyprland";

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # withUWSM = true;
  };

  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        xdg.portal = {
          enable = true;
          extraPortals = with pkgs; [
            xdg-desktop-portal-gtk
          ];
          xdgOpenUsePortal = true;
          #configPackages = [ config.wayland.windowManager.hyprland.package ];
          configPackages = [ inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland ];
          config.hyprland = {
            default = [
              "hyprland"
              "gtk"
            ];
            "org.freedesktop.impl.portal.OpenURI" = "gtk";
            "org.freedesktop.impl.portal.FileChooser" = "gtk";
            "org.freedesktop.impl.portal.Print" = "gtk";
          };
        };

        xdg.configFile."hypr/icons" = {
          source = ./icons;
          recursive = true;
        };

        # Set wallpaper
        services.awww.enable = true;

        #test later systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
        wayland.windowManager.hyprland = {
          enable = true;
          package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
          plugins = [
            #inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprwinwrap
            #inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.borders-plus-plus
            #pkgs.hyprlandPlugins.hyprtrails
            #pkgs.hyprlandPlugins.borders-plus-plus
            # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprwinwrap
            # inputs.hyprsysteminfo.packages.${pkgs.stdenv.hostPlatform.system}.default
            inputs.hyprkool.packages.${pkgs.stdenv.hostPlatform.system}.hyprkool-plugin 
          ];
          systemd = {
            enable = true;
            variables = [ "--all" ];
          };
          settings = {
            "$mainMod" = "SUPER";
            "$term" = "${getExe pkgs.${terminal}}";
            "$editor" = "code --disable-gpu";
            "$browser" = browser;

#            plugin = {
#                borders-plus-plus = {
#                    add_borders = 2;
#
#                    # INNER BORDER (static, subtle)"
#                    "col.border_1" = "rgba(50, 0, 20, 0.4)";
#                    border_size_1 = 4;
#
#                    # OUTER BORDER (animated)"
#                    "col.border_2" = "rgba(228, 149, 236, 0.831)";
#                    border_size_2 = 1;
#                    natural_rounding = 1;
#                };
#            };

            env = [
              "XDG_CURRENT_DESKTOP,Hyprland"
              "XDG_SESSION_DESKTOP,Hyprland"
              "XDG_SESSION_TYPE,wayland"
              "GDK_BACKEND,wayland,x11,*"
              "NIXOS_OZONE_WL,1"
              "ELECTRON_OZONE_PLATFORM_HINT,wayland"
              "MOZ_ENABLE_WAYLAND,1"
              "OZONE_PLATFORM,wayland"
              "EGL_PLATFORM,wayland"
              "CLUTTER_BACKEND,wayland"
              "SDL_VIDEODRIVER,wayland"
              "QT_QPA_PLATFORM,wayland;xcb"
              "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
              "QT_QPA_PLATFORMTHEME,qt6ct"
              "QT_AUTO_SCREEN_SCALE_FACTOR,1"
              "QT_ENABLE_HIGHDPI_SCALING,1"
              "WLR_RENDERER_ALLOW_SOFTWARE,1"
              "NIXPKGS_ALLOW_UNFREE,1"
            ];
            exec-once = [

              #"[workspace 1 silent] ${terminal}"
              #"[workspace 5 silent] ${browser}"
              #"[workspace 6 silent] spotify"
              #"[workspace special silent] ${browser} --private-window"
              #"[workspace special silent] ${terminal}"
              #"hyprsession"
              "librepods"
              #"caelestia-shell"
              "qs -c overview"
              "hyprkool daemon"
              "hyprpm reload -n"
              "${lib.getExe border-animation}"

              "${lib.getExe wallpaper}"
              "${bar}"
              "swaync"
              "nm-applet --indicator"
              # "wl-clipboard-history -t"
              "${getExe' pkgs.wl-clipboard "wl-paste"} --type text --watch cliphist store" # clipboard store text data
              "${getExe' pkgs.wl-clipboard "wl-paste"} --type image --watch cliphist store" # clipboard store image data
              "rm '$XDG_CACHE_HOME/cliphist/db'" # Clear clipboard
              #"${getExe batterynotify}" # battery notification
              "polkit-agent-helper-1"
            ];
            input = {
              kb_layout = "${kbdLayout},us";
              kb_variant = "${kbdVariant},";
              repeat_delay = 275; # or 212
              repeat_rate = 35;
              numlock_by_default = true;

              follow_mouse = 1;

              touchpad.natural_scroll = false;

              tablet.output = "current";

              sensitivity = 5.0; # -1.0 - 1.0, 0 means no modification.
              force_no_accel = true;
            };
            general = {
              gaps_in = 5;
              gaps_out = 6;
              border_size = 3;
              #"col.active_border" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
              #"col.inactive_border" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
              "col.inactive_border" = "rgba(50,0,20,0.5) rgba(60,0,80,0.3) 45deg";
              "col.active_border" = "rgba(250,120,220,0.6) rgba(210,120,250,0.6) 45deg";
              resize_on_border = true;
              layout = "dwindle"; # dwindle, master, scrolling, monocle
              # allow_tearing = true; # Allow tearing for games (use immediate window rules for specific games or all titles)
            };
            decoration = {
              shadow = {
                enabled = true;
                range = 25;
                render_power = 283;
                sharp = false;
                color = "rgba(0,0,0,1)";
                color_inactive = "rgba(0,0,0,0.8)";
                #shadow_ignore_window = true;
              };

              rounding = 10;
              dim_special = 0.3;
              blur = {
                enabled = true;
                special = true;
                size = 6; # 6
                passes = 2; # 3
                new_optimizations = true;
                ignore_opacity = true;
                xray = false;
              };
            };
#            group = {
#              "col.border_active" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
#              "col.border_inactive" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
#              "col.border_locked_active" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
#              "col.border_locked_inactive" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
#            };
            layerrule = (import ./windowrules.nix).layerrule;
            animations = {
              enabled = true;
              bezier = [
                "linear, 0, 0, 1, 1"
                "md3_standard, 0.2, 0, 0, 1"
                "md3_decel, 0.05, 0.7, 0.1, 1"
                "md3_accel, 0.3, 0, 0.8, 0.15"
                "overshot, 0.05, 0.9, 0.1, 1.1"
                "crazyshot, 0.1, 1.5, 0.76, 0.92"
                "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
                "fluent_decel, 0.1, 1, 0, 1"
                "easeInOutCirc, 0.85, 0, 0.15, 1"
                "easeOutCirc, 0, 0.55, 0.45, 1"
                "easeOutExpo, 0.16, 1, 0.3, 1"
              ];
              animation = [
                "windows, 1, 3, md3_decel, popin 60%"
                #"border, 1, 10, default"
                "fade, 1, 2.5, md3_decel"
                # "workspaces, 1, 3.5, md3_decel, slide"
                "workspaces, 0.4, 3.5, easeOutExpo, slide"
                # "workspaces, 1, 7, fluent_decel, slidefade 15%"
                # "specialWorkspace, 1, 3, md3_decel, slidefadevert 15%"
                "specialWorkspace, 0.6, 3, md3_decel, slidevert"
              ];
            };
            render = {
              direct_scanout = 0; # 0 = off, 1 = on, 2 = auto (on with content type ‘game’)
            };
            ecosystem = {
              no_update_news = true;
              no_donation_nag = true;
            };
            misc = {
              disable_hyprland_logo = true;
              mouse_move_focuses_monitor = true;
              swallow_regex = "^(Alacritty|kitty)$";
              enable_swallow = true;
              #vfr = false; # always keep on
              vrr = 2; # enable variable refresh rate (0=off, 1=on, 2=fullscreen only, 3 = fullscreen games/media)
            };
            xwayland.force_zero_scaling = false;
            gesture = [
              "3, horizontal, workspace"
            ];
            dwindle = {
              #pseudotile = true;
              preserve_split = true;
            };
            master = {
              new_status = "master";
              new_on_top = true;
              mfact = 0.5;
            };
            windowrule = (import ./windowrules.nix).windowrule;
            bind = (import ./keybinds.nix { inherit host lib pkgs inputs; }).bind;
            bindm = (import ./keybinds.nix { inherit host lib pkgs inputs; }).bindm;
            binde = (import ./keybinds.nix { inherit host lib pkgs inputs; }).binde;
            binds = {
              workspace_back_and_forth = 0;
              #allow_workspace_cycles=1
              #pass_mouse_when_bound=0
            };

            monitor = [
              # Easily plug in any monitor
              "eDP-1,preferred,auto,1.2"
              "HDMI-A-1, preferred, auto, 3, mirror,"

              # My Monitors (Fine to leave these since i used the serial numbers)
              "desc:BNQ BenQ EW277HDR 99J01861SL0,preferred,-1920x0,1"
              "desc:BNQ BenQ EL2870U PCK00489SL0,preferred,0x0,2"
              "desc:BNQ BenQ xl2420t 99D06760SL0,preferred,1920x-420,1,transform,1" # 5 for fipped
            ];

            workspace = [
              # Binds workspaces to my monitors (find desc with: hyprctl monitors)
            ];
          };
        };
      }
    )
  ];
}
