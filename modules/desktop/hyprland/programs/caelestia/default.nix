
{
  inputs,
  host,
  pkgs,
  ...
}:
let
  inherit (import ../../../../../hosts/${host}/variables.nix) clock24h bluetoothSupport;
in
{
  # Optional Dependencies
  environment.systemPackages = with pkgs; [
    wl-clipboard
    brightnessctl
    # wf-recorder
  ];
  home-manager.sharedModules = [
    (_: {
      imports = [
        inputs.noctalia.homeModules.default
      ];
      programs.caelestia = {
        enable = true;
        systemd.enable = true;
        settings = { }
      }
    }
  ]
}
