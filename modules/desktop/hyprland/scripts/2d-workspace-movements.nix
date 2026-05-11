
{
  pkgs,
  host,
  ...
}:
let
  script = builtins.readFile ./2d-workspace-grid.sh;
  inherit (import ../../../hosts/${host}/variables.nix)
    dim
    ;
in
pkgs.writeShellScriptBin "file-manager" ''
  DIMENSION="${dim}"
  ${script}
''
