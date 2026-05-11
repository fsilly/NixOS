
{
  pkgs,
  host,
  ...
}:
let
  script = builtins.readFile ./2d-workspace-grid.sh;
  inherit (import ../../../../hosts/${host}/variables.nix)
    ws_dim
    ;
in
pkgs.writeShellScriptBin "file-manager" ''
  DIMENSION="${ toString ws_dim }"
  ${script}
''
