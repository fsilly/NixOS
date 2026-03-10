{ inputs, pkgs, }:
with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
  ublock-origin
  dearrow
  bitwarden
]
