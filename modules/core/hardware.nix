{ pkgs, host, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) hostname bluetoothSupport;
in
{
  hardware = {
    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
      disabledDefaultBackends = [ "escl" ];
    };
    logitech.wireless.enable = false;
    logitech.wireless.enableGraphical = false;
    graphics.enable = true;
    enableRedistributableFirmware = true;
    keyboard.qmk.enable = true;
    bluetooth = {
      enable = bluetoothSupport;
      powerOnBoot = bluetoothSupport;
      settings = {
        General = {
          Name = hostname;
          ControllerMode = "dual";
          FastConnectable = true;
          Experimental = true;
          KernelExperimental = true;
          JustWorksRepairing = "always";
          SecureConnections = "on";
        };
        GATT = {
          Cache = "always";
          Channels = 3;
        };
        Policy = {
          AutoEnable = true;
          ReconnectAttempts = 7;
          ReconnectIntervals = "1,2,4,8,16,32,64";
          ResumeDelay = 1;
        };
      };
    };
  };
  services.autorandr = {
  enable = true;

  defaultTarget = "laptop";

  profiles = {
    laptop = {
      config = {
        eDP-1 = {
          enable = true;
          primary = true;
          mode = "1920x1080";
          position = "0x0";
        };
      };
    };
     fire = {
      config = {
        HDMI-A-1 = {
          enable = true;
          primary = true;
          mode = "1920x1080";
          position = "0x0";
        };
       DP-2 = {
          enable = true;
          primary = true;
          mode = "2560x1440";
          position = "0x0";
        };

        eDP-1.enable = false;
      };
    };


    hdmi = {
      config = {
        HDMI-A-1 = {
          enable = true;
          primary = true;
          mode = "1920x1080";
          position = "0x0";
        };

        eDP-1.enable = false;
      };
    };

    dp = {
      config = {
        DP-2 = {
          enable = true;
          primary = true;
          mode = "2560x1440";
          position = "0x0";
        };

        eDP-1.enable = false;
      };
    };
  };
};
}
