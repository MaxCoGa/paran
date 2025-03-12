#!/bin/bash
set -e

cd $PFS/sources

# with chroot!
run_script() {
    local script_dir="$1"
    local script="$2"
    echo "Running $script..."
    if ! sh "$script_dir/$script"; then
        echo "Error: $script failed with exit code $?"
        exit 1
    fi
}

SCRIPT_DIR=${1} # ${1:-./scripts} 

# Add scripting build here
scripts=(
    binutils-pass-1.sh
    gcc-pass-1.sh
    linux-api-headers.sh
    glibc.sh
    libstdc.sh
    m4.sh
    ncurses.sh
    bash.sh
    coreutils.sh
    diffutils.sh
    file.sh
    findutils.sh
    gawk.sh
    grep.sh
    gzip.sh
    make.sh
    patch.sh
    sed.sh
    tar.sh
    xz.sh
    binutils-pass-2.sh
    gcc-pass-2.sh
)

for script in "${scripts[@]}"; do
    run_script "$SCRIPT_DIR" "$script"
done

echo "All scripts completed successfully."
echo "Done building the toolchain."

# Usage ./toolchain.sh $PFS/build-scripts