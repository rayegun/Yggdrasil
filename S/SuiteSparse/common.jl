using BinaryBuilder, Pkg

version = v"5.10.1"

# Collection of sources required to build SuiteSparse
sources = [
    GitSource("https://github.com/DrTimothyAldenDavis/SuiteSparse.git",
              "538273cfd53720a10e34a3d80d3779b607e1ac26"),
]

# We enable experimental platforms as this is a core Julia dependency
platforms = supported_platforms(;experimental=true)

# The products that we will ensure are always built
products = [
    LibraryProduct("libsuitesparseconfig",   :libsuitesparseconfig; dont_dlopen=true),
    LibraryProduct("libamd",                 :libamd; dont_dlopen=true),
    LibraryProduct("libbtf",                 :libbtf; dont_dlopen=true),
    LibraryProduct("libcamd",                :libcamd; dont_dlopen=true),
    LibraryProduct("libccolamd",             :libccolamd; dont_dlopen=true),
    LibraryProduct("libcolamd",              :libcolamd; dont_dlopen=true),
    LibraryProduct("libcholmod",             :libcholmod; dont_dlopen=true),
    LibraryProduct("libldl",                 :libldl; dont_dlopen=true),
    LibraryProduct("libklu",                 :libklu; dont_dlopen=true),
    LibraryProduct("libumfpack",             :libumfpack; dont_dlopen=true),
    LibraryProduct("librbio",                :librbio; dont_dlopen=true),
    LibraryProduct("libspqr",                :libspqr; dont_dlopen=true),
]

# Dependencies that must be installed before this package can be built
dependencies = [
    Dependency("libblastrampoline_jll"),
]
