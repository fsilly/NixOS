{
  pkgs,
  inputs,
  host,
  ...
}:

let
  inherit (import ../../../../../hosts/${host}/variables.nix)
    clock24h
    username
    bluetoothSupport
    ;
  caelestiaSettings = {
    enabled = true;

    appearance = {
      deformScale = 1;
      anim.durations.scale = 1;

      font = {
        family = {
          clock = "Rubik";
          material = "Material Symbols Rounded";
          mono = "CaskaydiaCove NF";
          sans = "Rubik";
        };
        size.scale = 1;
      };

      padding.scale = 1;
      rounding.scale = 1;
      spacing.scale = 1;

      transparency = {
        enabled = true; # your override kept
        base = 0.85;
        layers = 0.4;
      };
    };

    general = {
      logo = "caelestia";
      mediaGifSpeedAdjustment = 300;
      sessionGifSpeed = 0.7;

      apps = {
        terminal = [ "foot" ];
        audio = [ "pavucontrol" ];
        playback = [ "mpv" ];
        explorer = [ "thunar" ];
      };

      battery = {
        warnLevels = [
          {
            level = 20;
            title = "Low battery";
            message = "You might want to plug in a charger";
            icon = "battery_android_frame_2";
          }
          {
            level = 10;
            title = "Did you see the previous message?";
            message = "You should probably plug in a charger <b>now</b>";
            icon = "battery_android_frame_1";
          }
          {
            level = 5;
            title = "Critical battery level";
            message = "PLUG THE CHARGER RIGHT NOW!!";
            icon = "battery_android_alert";
            critical = true;
          }
        ];
        criticalLevel = 3;
      };

      idle = {
        lockBeforeSleep = true;
        inhibitWhenAudio = true;
        timeouts = [
          {
            timeout = 180;
            idleAction = "lock";
          }
          {
            timeout = 300;
            idleAction = "dpms off";
            returnAction = "dpms on";
          }
          {
            timeout = 600;
            idleAction = [ "systemctl" "suspend-then-hibernate" ];
          }
        ];
      };
    };

    background = {
      enabled = true;
      wallpaperEnabled = true;

      desktopClock = {
        enabled = false;
        scale = 1.0;
        position = "bottom-right";

        shadow = {
          enabled = true;
          opacity = 0.7;
          blur = 0.4;
        };

        background = {
          enabled = false;
          opacity = 0.7;
          blur = true;
        };

        invertColors = false;
      };

      visualiser = {
        enabled = true;
        autoHide = true;
        blur = false;
        rounding = 1;
        spacing = 1;
      };
    };

    bar = {
      activeWindow = {
        compact = false;
        inverted = false;
        showOnHover = true;
      };

      clock = {
        showIcon = true;
        showDate = true;
        background = false;
      };

      dragThreshold = 20;
      persistent = true;
      showOnHover = true;

      popouts = {
        activeWindow = true;
        statusIcons = true;
        tray = true;
      };

      scrollActions = {
        brightness = true;
        workspaces = true;
        volume = true;
      };

      status = {
        showAudio = true;
        showBattery = true;
        showBluetooth = bluetoothSupport;
        showKbLayout = true;
        showMicrophone = false;
        showNetwork = true;
        showWifi = true;
        showLockStatus = true;
      };

      tray = {
        background = false;
        compact = false;
        iconSubs = [ ];
        recolour = false;
      };

      workspaces = {
        perMonitorWorkspaces = true;
        activeIndicator = true;
        activeTrail = false;
        showWindows = false;
        shown = 10;

        activeLabel = "󰮯";
        label = "  ";
        occupiedLabel = "󰮯";
        occupiedBg = false;

        specialWorkspaceIcons = [
          {
            name = "steam";
            icon = "sports_esports";
          }
        ];

        windowIcons = [
          {
            regex = "steam(_app_(default|[0-9]+))?";
            icon = "sports_esports";
          }
        ];
      };

      excludedScreens = [ "" ];

      entries = [
        { id = "logo"; enabled = true; }
        { id = "workspaces"; enabled = true; }
        { id = "spacer"; enabled = true; }
        { id = "activeWindow"; enabled = true; }
        { id = "spacer"; enabled = true; }
        { id = "tray"; enabled = true; }
        { id = "clock"; enabled = true; }
        { id = "statusIcons"; enabled = true; }
        { id = "power"; enabled = true; }
      ];
    };

    border = {
      rounding = 25;
      smoothing = 32;
      thickness = 10;
    };

    dashboard = {
      enabled = true;
      showOnHover = true;
      showDashboard = true;
      showMedia = true;
      showPerformance = true;
      showWeather = true;
      dragThreshold = 50;
      mediaUpdateInterval = 500;
    };

    lock = {
      recolourLogo = false;
      hideNotifs = false;
    };

    osd = {
      enabled = true;
      enableBrightness = true;
      enableMicrophone = false;
      hideDelay = 2000;
    };

    sidebar = {
      enabled = true;
      dragThreshold = 80;
    };
  };

  caelestiaShellJson = pkgs.writeText "caelestia-shell.json" (builtins.toJSON caelestiaSettings);
in
{
  environment.systemPackages = with pkgs; [
    wl-clipboard
    brightnessctl
  ];

  home-manager.sharedModules = [
    (
      { config, lib, ... }:
      {
        imports = [
          inputs.caelestia-shell.homeManagerModules.default
        ];

        programs.caelestia = {
          enable = true;
          cli.enable = true;
          systemd.enable = false;
        };

        home.activation.caelestiaWritableConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          mkdir -p "${config.xdg.configHome}/caelestia"

          if [ -L "${config.xdg.configHome}/caelestia/shell.json" ]; then
            rm "${config.xdg.configHome}/caelestia/shell.json"
          fi

          install -m 0644 "${caelestiaShellJson}" \
            "${config.xdg.configHome}/caelestia/shell.json"
        '';
      }
    )
  ];
}
