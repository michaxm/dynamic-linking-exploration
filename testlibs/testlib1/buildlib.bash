#!/bin/bash -e

mkdir -p build

rm -f build/*
ghc -outputdir build -shared -dynamic -fPIC src/Lib.hs -o libHStestlib1.so

rm -f build/*
ghc -outputdir build -dynamic -fPIC src/HsLib.hs
ghc -outputdir build -shared -dynamic build/HsLib.o -o libHStesthslib1.so
