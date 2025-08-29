#!/usr/bin/env bash
set -e

echo "🔧 Setting up BusyBox WebAssembly build environment..."

# Check if build already exists
if [ -f "build/wasm/busybox_unstripped.js" ]; then
    echo "✅ Build already exists. Run 'make clean-wasm' to rebuild from scratch."
else
    echo "📦 Building BusyBox WebAssembly..."
    make build/wasm/busybox_unstripped.js
    
    if [ -f "build/wasm/busybox_unstripped.js" ]; then
        echo "✅ Build successful!"
        echo ""
        echo "Available commands:"
        node build/wasm/busybox_unstripped.js --list 2>/dev/null | head -20
        echo "..."
        echo ""
        echo "Usage examples:"
        echo "  node build/wasm/busybox_unstripped.js ls"
        echo "  node build/wasm/busybox_unstripped.js echo 'Hello World'"
        echo "  node build/wasm/busybox_unstripped.js cat file.txt"
    else
        echo "❌ Build failed. Please check the errors above."
    fi
fi

echo ""
echo "Available make targets:"
echo "  make build/wasm/busybox_unstripped.js  - Build WebAssembly version"
echo "  make clean-wasm                         - Clean WebAssembly build"
echo "  make config                             - Configure BusyBox options"
echo ""