
{
  pkgs,
  ...
}:
let
  _terminal = "varexample";
  script = builtins.readFile ./2d-workspace-grid.sh;
in
pkgs.writeShellScriptBin "file-manager" ''
  TERMINAL="${_terminal}"
  ${script}
''
