#!/bin/bash -e
mkdir -p build
echo "c lib"
ghc -outputdir build -dynamic app/Main.hs -o dynlink-example -lctest -L./testlibs/c-linkage-example/ -optl-Wl,-rpath,/./testlibs/c-linkage-example/
./dynlink-example c

echo "hs lib"
ghc -outputdir build -dynamic app/Main.hs -o dynlink-example -lHStestlibFFI -L./testlibs/testlibFFI/ -optl-Wl,-rpath,/./testlibs/testlibFFI/
./dynlink-example hs-ffi || true

#TODO native ghc
#ghc -shared -dynamic -fPIC -outputdir build -o dynlink-example-ghc app/GHCRuntimeLinking.hs testlibs/testlib1/libHStesthslib1-1.0-ghc7.8.4.so -lHStestlibhs1 -L./testlibs/testlib1/ -optl-Wl,-rpath,./testlibs/testlib1/ -v 
echo "native ghc lib"
ghc -outputdir build -dynamic app/Main.hs -o dynlink-example -lHStesthslibHS1 -L./testlibs/testlibHS1/ -optl-Wl,-rpath,/./testlibs/testlibHS1/
./dynlink-example hs

