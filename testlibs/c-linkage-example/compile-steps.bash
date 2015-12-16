#!/bin/bash -e

./clean.bash

#see http://www.yolinux.com/TUTORIALS/LibraryArchives-StaticAndDynamic.html

echo "compile simple"
cc -Wall -c ctest1.c ctest2.c
#link lib
ar -cvq libctest.a ctest1.o ctest2.o
#display contents
#ar -t libctest.a
# compile+link executable
cc -o executable-name prog.c libctest.a
#or link lib "ctest" giving (this) path
#cc -o executable-name prog.c -L. -lctest
./executable-name

echo "shared lib"
gcc -Wall -fPIC -c ctest1.c ctest2.c
gcc -shared -Wl,-soname,libctest.so.1 -o libctest.so.1.0 ctest1.o ctest2.o
#show lib symbols
#readelf -s libctest.so.1.0
#show symbols
#nm libctest.so.1.0
#    mv libctest.so.1.0 /opt/lib
ln -sf libctest.so.1.0 libctest.so.1
ln -sf libctest.so.1.0 libctest.so
#link executable
gcc -Wall -I. -L. prog.c -lctest -o prog
export LD_LIBRARY_PATH=.
#show deps
ldd prog
./prog

echo "runtime lib"
gcc -rdynamic -o progdl progdl.c -ldl
./progdl
