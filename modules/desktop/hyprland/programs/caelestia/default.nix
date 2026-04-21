
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
 # 
 # home.packages = with inputs; [
 #   caelestia-shell.packages.${pkgs.system}.default
 # ];
}
