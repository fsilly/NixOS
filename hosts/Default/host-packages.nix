{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; with inputs; [
    obsidian
    ludusavi # For game saves
    proton-vpn # VPN
    vesktop
    # pokego # Overlayed
    # VPNs
    protonup-ng
    protonup-qt
    baobab

    proton-vpn-cli
    bitwarden-desktop
    bitwarden-menu

    vim
    #neovim
    tree-sitter
    ripgrep
    fd
    xclip
    wget
    gcc
    bat

    #vscode, unortunatly
    vscode

    lolcat
    vimb
    yt-dlp
    cheese
    pandoc
    glow
    w3m

    waycorner
    #inputs.hyprsession.packages.${pkgs.system}.default
    #"${inputs.hyprsession.packages.${pkgs.system}.hyprsession}/bin/hyprsession"

    zip
    ffmpeg
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
