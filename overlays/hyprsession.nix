{ pkgs ? import <nixpkgs> {} }:
let
  naersk = pkgs.fetchFromGitHub {
    owner = "nix-community";
    repo = "naersk";
    rev = pkgs.lib.importJSON (builtins.fetchurl "https://api.github.com/repos/nix-community/naersk/commits/master").sha;
    sha256 = "sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=";  # Run `nix build` once to get real hash
  };
  naersk' = pkgs.callPackage naersk {};
in
pkgs.stdenv.mkDerivation {
  pname = "hyprsession";
  version = "git";

  src = pkgs.fetchFromGitHub {
    owner = "joshurtree";
    repo = "hyprsession";
    rev = "master";  # Or specific commit
    sha256 = "sha256-YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY=";  # Update via `nix build`
  };

  nativeBuildInputs = with pkgs; [ naersk'.naersk rustc cargo pkg-config ];
  
  cargoSha256 = "sha256-ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=";  # Critical: Update after first build fail

  buildPhase = ''
    naersk build --release
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp target/release/hyprsession $out/bin/
  '';
}

