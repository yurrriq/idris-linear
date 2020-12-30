{ pkgs ? import ./nix }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    idris2
    myEmacs
    nixpkgs-fmt
    niv
  ];
}
