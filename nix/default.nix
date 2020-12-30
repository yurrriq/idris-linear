import (import ./sources.nix).nixpkgs {
  overlays =
    let
      path = ./overlays;
    in
    with builtins;
    map
      (n: import (path + ("/" + n)))
      (filter
        (n: match ".*\\.nix" n != null)
        (attrNames (readDir path))
      );
}
