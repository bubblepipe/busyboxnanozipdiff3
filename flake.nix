{
  description = "BusyBox WASM build environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            wget
            emscripten
          ];

          shellHook = ''
            alias emgcc=emcc
            echo "BusyBox WASM development environment"
            echo "Available tools:"
            echo "  - wget: $(which wget)"
            echo "  - emcc: $(which emcc)"
            echo "  - emgcc: aliased to emcc"
            echo "  - emscripten version: $(emcc --version | head -n1)"
          '';
        };
      });
}