#!/bin/bash -e

mkdir -p build
ghc -outputdir build -shared -dynamic -fPIC src/Lib.hs -o libHStestlib1.so
