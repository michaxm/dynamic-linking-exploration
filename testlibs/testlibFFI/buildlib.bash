#!/bin/bash -e

mkdir -p build

rm -f build/*
ghc -outputdir build -shared -dynamic -fPIC src/Lib.hs -o libHStestlibFFI.so
