#!/bin/bash -e

mkdir -p build

rm -f build/*
ghc -outputdir build -dynamic -fPIC src/HsLib.hs
ghc -outputdir build -dynamic -fPIC -shared build/HsLib.o -o libHStesthslibHS1.so
