{
  description = "BusyBox WASM build environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
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
            
            # Check if build exists and provide information
            if [ -f "build/wasm/busybox_unstripped.js" ]; then
              echo "✅ BusyBox WebAssembly build found!"
              echo "   Run 'node build/wasm/busybox_unstripped.js --list' to see all commands"
            else
              echo "⚠️  BusyBox WebAssembly not built yet!"
              echo "   Run './setup.sh' to build automatically, or"
              echo "   Run 'make build/wasm/busybox_unstripped.js' to build manually"
            fi
            
            echo "🛠️  Quick Commands:"
            echo "  busybox-wasm [cmd]      - Run BusyBox command directly"
            echo "  make clean-wasm          - Clean and rebuild"
            echo "  make config              - Configure BusyBox options"
            echo "  nix develop              - Re-enter this environment"
            echo ""
            echo "🎯 For k23 WebAssembly OS:"
            echo "  make -f Makefile.k23 build/k23/busybox.wasm - Build for k23"
            echo "  make -f Makefile.k23 clean-k23              - Clean k23 build"
            echo "  make -f Makefile.k23 test-k23               - Test k23 build"
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