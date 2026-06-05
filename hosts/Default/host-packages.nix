{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; with inputs; [
    obsidian
    ludusavi # For game saves
    godot # For game development
    proton-vpn # VPN
    github-desktop
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
    # All-in-one front-end for emulators 
#    (retroarch.withCores (cores: with cores; [
#      # citra # Nintendo - 3DS
#      dolphin # Nintendo - GameCube / Wii
#      # fbneo # Arcade
#      flycast # Sega - Dreamcast / Naomi
#      genesis-plus-gx # Sega - MS/GG/MD/CD
#      mame # Arcade
#      melonds # Nintendo - DS
#      mgba # Nintendo - Game Boy Advance
#      mupen64plus # Nintendo - N64
#      pcsx2 # Sony - PlayStation 2
#      ppsspp # Sony - PlayStation Portable (PSP)
#      picodrive # Sega - MD/32X
#      prosystem # Atari - 7800 / 2600
#      sameboy # Nintendo - Game Boy / Color
#      snes9x # Nintendo - SNES / SFC
#      swanstation # Sony - PlayStation
#    ]))
  ];
  
  # electron packages dynamic links
  programs.nix-ld.enable = true;

  # Mullvad service (optional but recommended)
  services.mullvad-vpn.enable = true;
}
