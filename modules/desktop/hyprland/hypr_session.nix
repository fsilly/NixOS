{ host, ... }:
let
  inherit (import ../../../hosts/${host}/variables.nix)
    bar
    ws_row 
    ws_col
    waybarTheme
    browser
    terminal
    fileManager
    kbdLayout
    kbdVariant
    defaultWallpaper
    wsSwitchTimeOffset
    ;
  evaluation_ws_position = x: y: (y - 1)*ws_row + (x -1) + 1;
  dispatch = { x, y, shell, clientX ? "", clientY ? "" }@client: "[workspace ${toString (evaluation_ws_position x y)} silent] ${shell}";
in
  [
    (dispatch { x =  1; y =  3; shell = "${terminal} ~/NixOS"; })
    (dispatch { x =  1; y =  3; shell = "${terminal} ~/NixOS"; })
    (dispatch { x =  1; y =  3; shell = "firefox"; })
    (dispatch { x =  2; y =  3; shell = "${browser}"; })
    (dispatch { x =  2; y =  5; shell = "vesktop"; })
    (dispatch { x =  2; y =  5; shell = "spotify"; })
    (dispatch { x =  2; y =  4; shell = "obsidian"; })
    (dispatch { x =  2; y =  4; shell = "${terminal} ~/Documents/'Here on earth'"; })
    (dispatch { x =  3; y =  3; shell = "${terminal}"; })
    (dispatch { x =  3; y =  3; shell = "${terminal}"; })
    (dispatch { x =  1; y =  1; shell = "${terminal}"; })
    (dispatch { x =  1; y =  1; shell = "${terminal}"; })
    (dispatch { x =  1; y =  2; shell = "${terminal}"; })
    (dispatch { x =  1; y =  2; shell = "${terminal}"; })
    (dispatch { x =  1; y =  4; shell = "${terminal}"; })
    (dispatch { x =  1; y =  4; shell = "${terminal}"; })
    (dispatch { x =  1; y =  5; shell = "${terminal}"; })
    (dispatch { x =  1; y =  5; shell = "${terminal}"; })
  ]
