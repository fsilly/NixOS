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

  caelestiaShellJson = pkgs.writeText "caelestia-shell.json" (builtins.toJSON caelestiaSettings);
in
{
  environment.systemPackages = with pkgs; [
    wl-clipboard
    brightnessctl
  ];

  home-manager = {
      xdg.configFile."caelestia" = {
        source = config.lib.file.mkOutOfStoreSymlink ./config.json;
        recursive = true;
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
  }
}
