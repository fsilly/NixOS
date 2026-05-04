{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; with inputs; [
    obsidian
    ludusavi # For game saves
    proton-vpn # VPN
    github-desktop
    vesktop
    # pokego # Overlayed
    # VPNs
    protonup-ng
    protonup-qt
    baobab

    proton-vpn-cli

    #nvim
    vim
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
    firefox
    vimb
    yt-dlp
    cheese
    pandoc

    waycorner
    #inputs.hyprsession.packages.${pkgs.system}.default
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
