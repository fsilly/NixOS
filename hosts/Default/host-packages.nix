{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; with inputs; [
    obsidian
    ludusavi # For game saves
    protonvpn-gui # VPN
    github-desktop
    vesktop
    # pokego # Overlayed
    # VPNs
    protonup-ng
    proton-vpn-cli

    vim
    firefox
    wget
    ripgrep
    nil
    neovim
    nixpkgs-fmt

    waycorner
    inputs.hyprsession.packages.${pkgs.system}.default
    #"${inputs.hyprsession.packages.${pkgs.system}.hyprsession}/bin/hyprsession"

    zip
    fastfetch
    thunderbird
    ente-auth
    # (pkgs.callPackage ../../overlays/hyprsession.nix { inherit pkgs; })

    # Audio / AirPods tool
    librepods
    libsForQt5.qtstyleplugin-kvantum 

  ];
  
  # electron packages dynamic links
  programs.nix-ld.enable = true;

  # Mullvad service (optional but recommended)
  services.mullvad-vpn.enable = true;
}
