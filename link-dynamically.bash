#!/bin/bash -e
mkdir -p build
echo "c lib"
ghc -outputdir build -dynamic app/Main.hs -o dynlink-example -lctest -L./testlibs/c-linkage-example/ -optl-Wl,-rpath,/./testlibs/c-linkage-example/
./dynlink-example c

echo "hs lib"
ghc -outputdir build -dynamic app/Main.hs -o dynlink-example -lHStestlib1 -L./testlibs/testlib1/ -optl-Wl,-rpath,/./testlibs/testlib1/
./dynlink-example hs
