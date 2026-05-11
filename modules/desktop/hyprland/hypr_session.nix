{ host, ... }:
let
  inherit (import ../../../hosts/${host}/variables.nix)
    bar
    ws_rows
    ws_cols
    waybarTheme
    browser
    terminal
    fileManager
    kbdLayout
    kbdVariant
    defaultWallpaper
    wsSwitchTimeOffset
    ;
  dispatch = { x, y, shell, clientX ? "", clientY ? "" }@client: "[workspace ${toString ((client.y - 1)*ws_rows + (client.x - 1) + 1)} silent] ${shell}";
in
  [
    (dispatch { x =  0; y =  0; shell = "${terminal} cd ~/NixOS && nv"; })
    (dispatch { x =  0; y =  0; shell = "${terminal} cd ~/NixOS"; })
    (dispatch { x =  0; y =  0; shell = "firefox"; })
    (dispatch { x =  1; y =  0; shell = "${browser}"; })
    (dispatch { x =  1; y =  1; shell = "obsidian"; })
    (dispatch { x =  1; y =  1; shell = "${terminal} nv"; })
    (dispatch { x =  0; y =  1; shell = "${terminal}"; })
    (dispatch { x =  0; y =  1; shell = "${terminal}"; })
    (dispatch { x =  0; y =  2; shell = "${terminal}"; })
    (dispatch { x =  0; y =  2; shell = "${terminal}"; })
    (dispatch { x =  0; y =  3; shell = "${terminal}"; })
    (dispatch { x =  0; y =  3; shell = "${terminal}"; })
  ]
