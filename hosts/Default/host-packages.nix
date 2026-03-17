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

    waycorner

    zip
    fastfetch
    thunderbird
    ente-auth
    # (pkgs.callPackage ../../overlays/hyprsession.nix { inherit pkgs; })

    # Audio / AirPods tool
    librepods

    # js
    nodejs
    electron
  ];
  
  # electron packages dynamic links
  programs.nix-ld.enable = true;

  # Mullvad service (optional but recommended)
  services.mullvad-vpn.enable = true;
}
