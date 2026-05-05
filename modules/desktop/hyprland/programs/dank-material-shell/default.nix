
{
  pkgs,
  inputs,
  host,
  ...
}:

let
  inherit (import ../../../../../hosts/${host}/variables.nix)
    username
    ;
in
{
  imports = [
      #inputs.dms.nixosModules.dank-material-shell
  ];
  environment.systemPackages = [
      #inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.dms-shell
  ];

  home-manager = {
      users.${username} = { config, lib, pkgs, ... }: {
          xdg.configFile."DankMaterialShell/plugins/AIAssistant" = {
            source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/NixOS/hosts/${host}/xdgconfig/DankMaterialShell/AIAssistant";
            recursive = true;
          };
      };
      sharedModules = [
        (
          { config, lib, ... }:
          {
            imports = [
            ];
          }
        )
      ];
    };
}
