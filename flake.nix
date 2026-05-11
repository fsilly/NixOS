{
  description = "A simple flake for an atomic system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";
    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = ""; # Doesn't use nixpkgs
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.noctalia-qs.follows = "noctalia-qs";
    };
    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        caelestia-cli.follows = "caelestia-cli";
      };
    };
    caelestia-cli = {
      url = "github:fsilly/caelestia-cli?ref=cute";
    };

    hyprland = {
        #url = "github:hyprwm/Hyprland/6ec0228c38a6203e4789fe7e7e793a558521c109"; # 0.54.0
        url = "github:hyprwm/Hyprland/521ece4"; # 0.54.3
        #url = "github:hyprwm/Hyprland";
        #inputs.nixpkgs.follows = "nixpkgs";
        #follows = "hyprland-plugins/hyprland";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprland.follows = "hyprland";
    };
    hyprkool = {
      url = "github:shinkuan/hyprkool";
      inputs.hyprland.follows = "hyprland";
    };
    hyprgrass = {
       url = "github:horriblename/hyprgrass";
       inputs.hyprland.follows = "hyprland"; 
        inputs.nixpkgs.follows = "nixpkgs";
    };

    doom-config = {
      url = "github:Sly-Harvey/doom";
      flake = false;
    };
    nixvim = {
      url = "github:fsilly/nixvim/fsilly-changes";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #neovim = {
    #  url = "github:Sly-Harvey/nvim";
    #  flake = false;
    #};
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    betterfox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
    };
    thunderbird-catppuccin = {
      url = "github:catppuccin/thunderbird";
      flake = false;
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    nvchad4nix = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprsession = {
		url = "github:joshurtree/hyprsession";
        inputs.nixpkgs.follows = "nixpkgs";
	};
    nixos-grub-themes = {
		url = "github:jeslie0/nixos-grub-themes";
        inputs.nixpkgs.follows = "nixpkgs";
	};
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      mkHost =
        host:
        let
          inherit (import ./hosts/${host}/variables.nix) username;
        in
        nixpkgs.lib.nixosSystem {
          # inherit system;
          system = forAllSystems (system: system);
          modules = [
            ./hosts/${host}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              nixpkgs.overlays = [
                inputs.nur.overlays.default
              ];
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;

                } ;
            }
          ];
          specialArgs = {
            overlays = import ./overlays { inherit inputs host; };
            inherit
              self
              inputs
              outputs
              host
              ;
          };
        };
    in
    {
      templates = import ./dev-shells;
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
      devShells.default = nixpkgs.mkShell {
        packages = with nixpkgs; [
          git
          just
          fd
          ripgrep
          entr
          statix
          deadnix
          nixd
          nil
          alejandra

          # local nixvim build
          nvim
        ];

        shellHook = ''
          echo "hum yeah shell thing good"
        '';
      };
      nixosConfigurations = {
        Default = mkHost "Default";
      };
    };
}
