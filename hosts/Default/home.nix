
{
  config,
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
in {
  ${username} = {
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
        credential = {
          username = "fsilly";
        };
      };
    };
    xdg.configFile."waycorner" = {
      source = config.lib.file.mkOutOfStoreSymlink ./waycorner;
    };
  };
}
