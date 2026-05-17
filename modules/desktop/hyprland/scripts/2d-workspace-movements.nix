
{
  pkgs,
  host,
  ...
}:
let
  script = builtins.readFile ./2d-workspace-grid.sh;
  inherit (import ../../../../hosts/${host}/variables.nix)
    ws_col
    ws_row
    ws_topology
    ;
in
pkgs.writeShellScriptBin "file-manager" ''
  WS_COL=${toString ws_col}
  WS_ROW=${toString ws_row}
  WS_TOPOLOGY=${ws_topology}
  WS_SPEED=1
  WS_FUNCTION=default
  ${script}
''
