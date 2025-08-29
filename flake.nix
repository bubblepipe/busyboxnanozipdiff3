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
            ncurses
            pkg-config
            gcc
          ];

          shellHook = ''
            # Set up aliases
            alias emgcc=emcc
            alias busybox-wasm='node build/wasm/busybox_unstripped.js'
            
            echo "========================================="
            echo "🚀 BusyBox WASM Development Environment"
            echo "========================================="
            echo ""
            echo "📦 Build Tools:"
            echo "  - emcc: $(emcc --version | head -n1)"
            echo "  - wget: available"
            echo "  - ncurses: available (for menuconfig)"
            echo ""
            
            # Run setup if it exists
            if [ -f "./setup.sh" ]; then
              ./setup.sh
            fi
            
            echo "🛠️  Quick Commands:"
            echo "  busybox-wasm [cmd]      - Run BusyBox command directly"
            echo "  make clean-wasm          - Clean and rebuild"
            echo "  make config              - Configure BusyBox options"
            echo "  nix develop              - Re-enter this environment"
            echo ""
            echo "📚 Examples:"
            echo "  busybox-wasm ls"
            echo "  busybox-wasm echo 'Hello World'"
            echo "  busybox-wasm cat README.md"
            echo "========================================="
          '';
        };
      });
}