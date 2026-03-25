{
  username = "briar"; # auto-set with install.sh, live-install.sh, and rebuild scripts.

  # Desktop Environment
  desktop = "hyprland"; # hyprland, i3, gnome, plasma6

  # Theme & Appearance
  bar = "noctalia"; # waybar, hyprpanel, noctalia
  waybarTheme = "stylish"; # stylish, minimal
  sddmTheme = "hyprland_kath"; # astronaut, black_hole, purple_leaves, jake_the_dog, hyprland_kath
  defaultWallpaper = "cyberpunk.webp"; # Change with SUPER + SHIFT + W (Hyprland)
  hyprlockWallpaper = "cyberpunk.webp";

  # Default Applications
  terminal = "kitty"; # kitty, alacritty
  editor = "neovim"; # nixvim, vscode, helix, doom-emacs, nvchad, neovim
  browser = "zen-beta"; # zen-beta, firefox, floorp
  tuiFileManager = "yazi"; # yazi, lf
  shell = "zsh"; # zsh, bash
  games = false; # Enable/Disable gaming module

  # Hardware
  hostname = "BriarAssSweat";
  videoDriver = "nvidia"; # nvidia, amdgpu, intel
  bluetoothSupport = true; # Whether your motherboard supports bluetooth

  # Localization
  timezone = "Europe/Paris";
  locale = "en_US.UTF-8";
  clock24h = true;
  kbdLayout = "us";
  kbdVariant = "";
  consoleKeymap = "us";
}
