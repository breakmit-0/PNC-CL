#!/bin/env sh

mkdir build


mkdir build/package
rm -r build/package/*

cd src
zip -r ../build/package/toolbox.zip .
cd -

cp README.md build/package/README.md


zip -r build/package/source-code.zip .

rm build/lift-ppl.zip
cd build/package
zip -r ../lift-ppl.zip .
cd -



