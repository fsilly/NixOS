{
  pkgs,
  inputs,
  host,
  ...
}:
let
  inherit (import ../../hosts/${host}/variables.nix)
    username
    editor
    terminal
    browser
    shell
    ;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  programs.dconf.enable = true; # Enable dconf for home-manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    overwriteBackup = true;
    backupFileExtension = "backup";
    users.${username} = { config, lib, pkgs, ... }: {
      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
      xdg.enable = true;

      xdg.configFile."waycorner" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/NixOS/hosts/${host}/xdgconfig/waycorner/";
        recursive = true;
      };
      xdg.configFile."nvim" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/NixOS/hosts/${host}/xdgconfig/nvim/";
        recursive = true;
      };
      xdg.configFile."quickshell/overview" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/NixOS/hosts/${host}/xdgconfig/quickshell/overview";
        recursive = true;
      };
      xdg.configFile."hypr/hyprkool.toml" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/NixOS/hosts/${host}/xdgconfig/hypr/hyprkool.toml";
        recursive = true;
      };
      programs.gh = {
        enable = true;
        gitCredentialHelper = {
          enable = true;
        };
      };
      programs.git = {
        enable = true;
        settings = {
          user = {
            name = "fsilly";
            email = "naykeysnet@gmail.com";
          };
        };
      };
      programs.quickshell = {
        enable = true;
        activeConfig = null;
        configs = {
            #caelestia-shell = (inputs.caelestia-shell.packages.${pkgs.system}.default.override { withCli = true; });
            #hyprkool = inputs.hyprkool.packages.${pkgs.system}.default;

        };
      };

      home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = "26.05"; # Do not change!
        packages = with pkgs; [
          neovim
          ripgrep
          nil
          nixpkgs-fmt
          qt6.qtwayland
          #inputs.caelestia-shell.packages.${pkgs.system}.default
          inputs.hyprkool.packages."${pkgs.system}".default
        ];
        sessionVariables = {
          EDITOR =
            if (editor == "nixvim" || editor == "neovim" || editor == "nvchad") then
              "nvim"
            else if editor == "vscode" then
              "code"
            else
              "nano";
          BROWSER = "${browser}";
          TERMINAL = "${terminal}";
        };
      };    
    }; 
  };
  users = {
    mutableUsers = true;
    users.${username} = {
      isNormalUser = true;
      initialPassword = "123";
      extraGroups = [
        "wheel" # sudo access
        "input"
        "networkmanager"
        "video"
        "audio"
        "libvirtd"
        "kvm"
        "docker"
        "disk"
        "adbusers"
        "lp"
        "scanner"
        "vboxusers" # Virtual Box
      ];
      shell = pkgs.${shell};
      ignoreShellProgramCheck = true;
    };
  };
  nix.settings.allowed-users = [ "${username}" ];
}
