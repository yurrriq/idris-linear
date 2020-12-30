_: pkgs: {
  myEmacs = pkgs.emacsWithPackages (epkgs: (with epkgs.melpaPackages; [
    better-defaults
    crux
    direnv
    editorconfig
    fill-column-indicator
    hl-todo
    idris-mode
    multiple-cursors
    nix-mode
    smex
    use-package
    whitespace-cleanup-mode
    yaml-mode
  ]));
}
