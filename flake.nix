{
  description = "yo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        python = pkgs.python311;
      in
      {
        devShells.default = pkgs.mkShell {

          packages = [
            python
            pkgs.pipx
            pkgs.git
            pkgs.gh
          ];

          shellHook = ''
            export PIPX_HOME="$PWD/.pipx"
            export PIPX_BIN_DIR="$PWD/.pipx/bin"
            export PATH="$PIPX_BIN_DIR:$PATH"

            if ! command -v zmk >/dev/null 2>&1; then
              echo "Installing ZMK CLI via pipx..."
              pipx install zmk
            fi
          '';
        };
      }
    );
}
