#!/bin/bash
set -e

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
    man-pages.sh
    iana-etc.sh
    glibc.sh
    zlib.sh
    bzip2.sh
    xz.sh
    zstd.sh
    file.sh
    readline.sh
    m4.sh
    bc.sh
    flex.sh
    tcl.sh
    expect.sh
    dejagnu.sh
    pkgconf.sh
    binutils.sh
    gmp.sh
    mpfr.sh
    mpc.sh
    attr.sh
    acl.sh
    libcap.sh
    libxcrypt.sh
    shadow.sh
    gcc.sh
    ncurses.sh
    sed.sh
    psmisc.sh
    gettext.sh
    bison.sh
    grep.sh
    bash.sh
    libtool.sh
    gdbm.sh
    gperf.sh
    expat.sh
    inetutils.sh
    less.sh
    perl.sh
    xml-parser.sh
    intltool.sh
    autoconf.sh
    automake.sh
    openssl.sh
    kmod.sh
    elfutils.sh
    libffi.sh
    python.sh
    flit-core.sh
    wheel.sh
    setuptools.sh
    ninja.sh
    meson.sh
    coreutils.sh
    check.sh
    diffutils.sh
    gawk.sh
    findutils.sh
    groff.sh
    grub.sh
    gzip.sh
    iproute2.sh
    kbd.sh
    libpipeline.sh
    make.sh
    patch.sh
    tar.sh
    texinfo.sh
    vim.sh
    markupsafe.sh
    jinja2.sh
    systemd.sh
    dbus.sh
    mandb.sh
    procps.sh
    utillinux.sh
    e2fsprogs.sh
)

for script in "${scripts[@]}"; do
    run_script "$SCRIPT_DIR" "$script"
done

echo "All scripts completed successfully."
echo "Done building base packages."