# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder, Pkg

name = "OpenLSTO"
version = v"1.0"

# Collection of sources required to complete build
sources = [
    GitSource("https://github.com/M2DOLab/OpenLSTO.git", "853b9cc433b84c60cd1318a36f9a1d0e6cf65877"),
    DirectorySource("./bundled")
]

# Bash recipe for building across all platforms
script = raw"""
atomic_patch -p1 patches/fixeigenpath.patch
cp makefile_FEA $WORKSPACE/srcdir/OpenLSTO/M2DO_FEA/makefile
cp makefile_LSM $WORKSPACE/srcdir/OpenLSTO/M2DO_LSM/makefile
cd $WORKSPACE/srcdir/OpenLSTO
atomic_patch -p1 ../patches/include.patch
cd $WORKSPACE/srcdir/OpenLSTO/M2DO_FEA
make all
make install
cd ../M2DO_LSM
mkdir bin
make all
make install
install_license ${WORKSPACE}/srcdir/OpenLSTO/LICENSE
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = expand_cxxstring_abis(supported_platforms(; experimental=true))
filter!(p -> !(Sys.isapple(p) && arch(p) == "aarch64"), platforms)
# The products that we will ensure are always built
products = [
    LibraryProduct("m2do_fea", :m2do_fea)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    Dependency("Eigen_jll"),
    Dependency("CompilerSupportLibraries_jll")
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies; preferred_gcc_version=v"6", julia_compat="1.7")
