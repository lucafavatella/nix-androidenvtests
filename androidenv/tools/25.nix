{deployAndroidPackage, lib, package, autopatchelf, makeWrapper, os, pkgs, pkgs_i686, postInstall ? ""}:

deployAndroidPackage {
  buildInputs = [ autopatchelf makeWrapper ];
  libs_x86_64 = lib.optionalString (os == "linux") lib.makeLibraryPath [ pkgs.glibc pkgs.xlibs.libX11 pkgs.xlibs.libXext pkgs.xlibs.libXdamage pkgs.xlibs.libxcb pkgs.xlibs.libXfixes pkgs.xlibs.libXrender pkgs.fontconfig pkgs.freetype pkgs.libGL pkgs.zlib pkgs.ncurses5 pkgs.libpulseaudio ];
  libs_i386 = lib.optionalString (os == "linux") lib.makeLibraryPath [ pkgs_i686.glibc pkgs_i686.xlibs.libX11 pkgs_i686.xlibs.libXrender pkgs_i686.fontconfig pkgs_i686.freetype pkgs_i686.zlib ];
  inherit package os;

  patchInstructions = ''
    ${lib.optionalString (os == "linux") ''
      # Auto patch all binaries
      libs_x86_64=$PWD/lib64:$PWD/lib64/libstdc++:$PWD/lib64/qt/lib:$libs_x86_64
      libs_i386=$PWD/lib:$PWD/lib/libstdc++:$libs_i386
      autopatchelf .
    ''}

    # Wrap all scripts that require JAVA_HOME
    for i in bin
    do
        find $i -maxdepth 1 -type f -executable | while read program
        do
            if grep -q "JAVA_HOME" $program
            then
                wrapProgram $PWD/$program --prefix PATH : ${pkgs.jdk8}/bin
            fi
        done
    done

    # Wrap programs that require java
    for i in draw9patch jobb lint screenshot2
    do
        wrapProgram $PWD/$i \
          --prefix PATH : ${pkgs.jdk8}/bin
    done

    # Wrap programs that require java and SWT
    for i in android ddms hierarchyviewer monitor monkeyrunner traceview uiautomatorviewer
    do
        wrapProgram $PWD/$i \
          --prefix PATH : ${pkgs.jdk8}/bin \
          --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ pkgs.xlibs.libX11 pkgs.xlibs.libXtst ]}
    done

    wrapProgram $PWD/emulator \
      --prefix PATH : ${pkgs.file}/bin

    # Patch all script shebangs
    patchShebangs .

    cd ..
    ${postInstall}
  '';
}