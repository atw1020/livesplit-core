set -ex

main() {
    local cargo=cross

    # all features except those that sometimes should be skipped.
    local features="--features std,more-image-formats,image-shrinking,rendering,path-based-text-engine,wasm-web,font-loading"

    if [ "$SKIP_CROSS" = "skip" ]; then
        cargo=cargo
    fi

    if [ "$SKIP_AUTO_SPLITTING" != "skip" ]; then
        features="$features,auto-splitting"
    fi

    if [ "$SKIP_NETWORKING" != "skip" ]; then
        features="$features,networking"
    fi

    if [ "$TARGET" = "wasm32-wasi" ]; then
        curl https://wasmtime.dev/install.sh -sSf | bash
        export PATH="$HOME/.wasmtime/bin:$PATH"
        $cargo test -p livesplit-core --features software-rendering --target $TARGET
        return
    fi

    $cargo test -p livesplit-core $features --target $TARGET
    $cargo test -p livesplit-core --no-default-features --features std --target $TARGET
}

main
