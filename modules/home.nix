{
  pkgs,
  inputs,
  host,
  ...
}:
let
  inherit (import ../hosts/${host}/variables.nix)
    username
    editor
    terminal
    browser
    shell
    ;
in {
  ${username} = {
    programs.git = {
      enable = true;
      settings.user = {
        name = "John Doe";
        email = "johndoe@example.com";
      };
    };
  };
}
