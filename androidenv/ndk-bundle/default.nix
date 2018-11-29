{deployAndroidPackage, lib, package, os, autopatchelf, makeWrapper, pkgs, platform-tools}:

let
  runtime_paths = lib.makeBinPath [ pkgs.coreutils pkgs.file pkgs.findutils pkgs.gawk pkgs.gnugrep pkgs.gnused pkgs.jdk pkgs.python3 pkgs.which ] + ":${platform-tools}/platform-tools";
in
deployAndroidPackage {
  inherit package os;
  buildInputs = [ autopatchelf makeWrapper ];
  libs_x86_64 = lib.optionalString (os == "linux") (lib.makeLibraryPath [ pkgs.glibc pkgs.stdenv.cc.cc pkgs.ncurses5 pkgs.zlib pkgs.libcxx ]);
  patchInstructions = lib.optionalString (os == "linux") ''
    patchShebangs .

    patch -p1 \
      --no-backup-if-mismatch < ${./make_standalone_toolchain.py_18.patch}
    wrapProgram $(pwd)/build/tools/make_standalone_toolchain.py --prefix PATH : "${runtime_paths}"

    # TODO: allow this stuff
    rm -rf docs tests

    # Patch the executables of the toolchains, but not the libraries -- they are needed for crosscompiling
    libs_x86_64=$out/libexec/android-sdk/ndk-bundle/toolchains/renderscript/prebuilt/linux-x86_64/lib64:$libs_x86_64

    find toolchains -type d -name bin | while read dir
    do
        autopatchelf "$dir"
    done

    # fix ineffective PROGDIR / MYNDKDIR determination
    for i in ndk-build
    do
        sed -i -e 's|^PROGDIR=`dirname $0`|PROGDIR=`dirname $(readlink -f $(which $0))`|' $i
    done

    # Patch executables
    autopatchelf prebuilt/linux-x86_64

    # wrap
    for i in ndk-build
    do
        wrapProgram "$(pwd)/$i" --prefix PATH : "${runtime_paths}"
    done

    # make some executables available in PATH
    mkdir -p $out/bin
    for i in ndk-build
    do
        ln -sf ../../libexec/android-sdk/ndk-bundle/$i $out/bin/$i
    done
  '';

  noAuditTmpdir = true; # Audit script gets invoked by the build/ component in the path for the make standalone script
}
