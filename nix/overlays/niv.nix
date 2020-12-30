_: pkgs: {
  inherit (import (import ../sources.nix).niv { inherit pkgs; }) niv;
}
