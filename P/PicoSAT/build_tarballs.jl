# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder, Pkg

name = "PicoSAT"
version = v"965.0.0"

# Collection of sources required to complete build
sources = [
    ArchiveSource("http://fmv.jku.at/picosat/picosat-965.tar.gz", "15169b4f28ba8f628f353f6f75a100845cdef4a2244f101a02b6e5a26e46a754")
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/picosat-965
if [[ ${target} == *musl* ]]; then
    sed -i 's!sys/unistd.h!unistd.h!g' picosat.c
fi
if [[ ${target} == *mingw* ]]; then
    sed -i 's!case X"$CC" in!case X"$target" in!g' configure.sh
fi
if [[ "${nbits}" == 32 ]]; then
    ./configure.sh --shared --32
else
    ./configure.sh --shared
fi

make
mkdir -p ${bindir} && cp ${WORKSPACE}/srcdir/picosat-965/{picosat${exeext},picomus${exeext},picomcs${exeext},picogcnf${exeext}} ${bindir}/
mkdir -p ${libdir} && cp ${WORKSPACE}/srcdir/picosat-965/libpicosat.${dlext} ${libdir}/
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products = [
    ExecutableProduct("picosat", :picosat),
    ExecutableProduct("picomus", :picomus),
    ExecutableProduct("picomcs", :picomcs),
    ExecutableProduct("picogcnf", :picogcnf),
    LibraryProduct("libpicosat",:libpicosat)
]

# Dependencies that must be installed before this package can be built
dependencies = Dependency[
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies; preferred_gcc_version = v"5.2.0")
