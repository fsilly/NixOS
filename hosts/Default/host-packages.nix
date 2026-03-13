{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    obsidian
    ludusavi # For game saves
    protonvpn-gui # VPN
    github-desktop
    vesktop
    # pokego # Overlayed
    # VPNs
    protonup-ng
    proton-vpn-cli
    mullvad-vpn

    # Audio / AirPods tool
    librepods
  ];
  # Mullvad service (optional but recommended)
  services.mullvad-vpn.enable = true;
}
