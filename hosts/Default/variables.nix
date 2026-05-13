{
  username = "briar"; # auto-set with install.sh, live-install.sh, and rebuild scripts.

  # Desktop Environment
  desktop = "hyprland"; # hyprland, i3, gnome, plasma6

  # Theme & Appearance
  bar = "caelestia-shell"; # waybar, hyprpanel, noctalia, caelestia-shell
  waybarTheme = "stylish"; # stylish, minimal
  sddmTheme = "hyprland_kath"; # astronaut, black_hole, purple_leaves, jake_the_dog, hyprland_kath
  defaultWallpaper = "girlsleepdesk.webp"; # Change with SUPER + SHIFT + W (Hyprland)
  hyprlockWallpaper = "girlsleepdesk.webp";
  # Default Applications
  terminal = "kitty"; # kitty, alacritty
  editor = "nixvim"; # nixvim, vscode, helix, doom-emacs, nvchad, neovim
  browser = "zen-beta"; # zen-beta, firefox, floorp
  fileManager = "yazi"; # yazi, lf, thunar
  shell = "zsh"; # zsh, bash
  games = true; # Enable/Disable gaming module

  # Hardware
  hostname = "BriarAssSweat";
  videoDriver = "nvidia"; # nvidia, amdgpu, intel
  bluetoothSupport = true; # Whether your motherboard supports bluetooth
  nvidiaChannel = "legacy_580"; # stable, latest, beta, legacy_xxx

  wsSwitchTimeOffset = "0";
  ws_row = 5;
  ws_col = 5;
  ws_topology = "plane";

  # Localization
  timezone = "Europe/Paris";
  locale = "en_US.UTF-8";
  clock24h = true;
  kbdLayout = "us";
  consoleKeymap = "us";
  kbdVariant = "";
  #kbdVariant = "extd";
  capslockAsESC = true;
}
