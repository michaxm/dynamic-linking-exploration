#!/bin/bash -e
mkdir -p build
echo "c lib"
ghc -outputdir build -dynamic app/Main.hs -o dynlink-example -lctest -L./testlibs/c-linkage-example/ -optl-Wl,-rpath,/./testlibs/c-linkage-example/
./dynlink-example c

echo "hs lib"
ghc -outputdir build -dynamic app/Main.hs -o dynlink-example -lHStestlib1 -L./testlibs/testlib1/ -optl-Wl,-rpath,/./testlibs/testlib1/
./dynlink-example hs


#TODO native ghc
#ghc -shared -dynamic -fPIC -outputdir build -o dynlink-example-ghc app/GHCRuntimeLinking.hs testlibs/testlib1/libHStesthslib1-1.0-ghc7.8.4.so -lHStestlibhs1 -L./testlibs/testlib1/ -optl-Wl,-rpath,./testlibs/testlib1/ -v 
