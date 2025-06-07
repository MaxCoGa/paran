#!/bin/bash
set -e

# with chroot!
run_script() {
    local script_dir="$1"
    local script="$2"
    echo "Running $script..."
    if ! sh -e "$script_dir/$script"; then
        echo "Error: $script failed with exit code $?"
        exit 1
    fi
}

SCRIPT_DIR=${1} # ${1:-./scripts} 

# Add scripting build here
scripts=(
    libunistring.sh
    libpsl.sh
    curl.sh
    git.sh

    libburn.sh
    libisofs.sh
    libisoburn.sh

    libidn2.sh
    wget.sh

    libarchive.sh
    cpio.sh
)

for script in "${scripts[@]}"; do
    run_script "$SCRIPT_DIR" "$script"
done

echo "All scripts completed successfully."
echo "Done building base packages."