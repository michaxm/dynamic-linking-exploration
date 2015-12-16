#!/bin/bash -e
mkdir -p build
ghc -outputdir build -dynamic app/Main.hs -o dynlink-example -lctest -L./testlibs/c-linkage-example/ -optl-Wl,-rpath,/./testlibs/c-linkage-example/
echo "without root rights, the  demo program seems to segfault on exit"
./dynlink-example
