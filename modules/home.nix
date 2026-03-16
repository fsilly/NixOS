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
in {
  ${username} = {
    homeConfiguration.briar = {
      programs.git = {
        enable = true;
        settings.user = {
          name = "John Doe";
          email = "johndoe@example.com";
        };
      };
    };
  };
}
