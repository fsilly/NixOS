
{
  pkgs,
  terminal,
  ...
}:
let
  script = builtins.readFile ./2d-workspace-grid.sh;
in
pkgs.writeShellScriptBin "file-manager" ''
  TERMINAL="${terminal}"
  ${script}
''
