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
    (dispatch { x =  1; y =  1; shell = "${terminal} ~/NixOS"; })
    (dispatch { x =  1; y =  1; shell = "${terminal} ~/NixOS"; })
    (dispatch { x =  1; y =  1; shell = "firefox"; })
    (dispatch { x =  2; y =  1; shell = "${browser}"; })
    (dispatch { x =  2; y =  2; shell = "obsidian"; })
    (dispatch { x =  2; y =  2; shell = "${terminal} ~/Documents/'Here on earth'"; })
    (dispatch { x =  1; y =  2; shell = "${terminal}"; })
    (dispatch { x =  1; y =  2; shell = "${terminal}"; })
    (dispatch { x =  1; y =  3; shell = "${terminal}"; })
    (dispatch { x =  1; y =  3; shell = "${terminal}"; })
    (dispatch { x =  1; y =  4; shell = "${terminal}"; })
    (dispatch { x =  1; y =  4; shell = "${terminal}"; })
  ]
