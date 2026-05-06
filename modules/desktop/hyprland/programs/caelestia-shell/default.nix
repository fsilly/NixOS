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
in
{
  environment.systemPackages = with pkgs; [
    wl-clipboard
    wf-recorder
    #vaapi
    #gsr-kms-server
    gpu-screen-recorder
    brightnessctl
  ];

  home-manager = {
      users.${username} = { config, lib, pkgs, ... }: {
          xdg.configFile."caelestia" = {
            #source = config.lib.file.mkOutOfStoreSymlink ./config/;
            source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/NixOS/modules/desktop/hyprland/programs/caelestia-shell/caelestia";
            recursive = true;
          };
      };
      sharedModules = [
        (
          { config, lib, ... }:
          {
            imports = [
              inputs.caelestia-shell.homeManagerModules.default
            ];

            # Pointer cursor
            home.pointerCursor = {
              gtk.enable = true;
              x11.enable = true;
              package = pkgs.bibata-cursors;
              name = "Bibata-Modern-Classic";
              size = 24;
            };

            programs.caelestia = {
              enable = true;
              cli.enable = true;
              systemd.enable = false;
            };
          }
        )
      ];
  };
}
