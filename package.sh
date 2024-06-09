#!/bin/env sh

mkdir build


mkdir build/package
rm -r build/package/*

cd src
zip -r ../build/package/toolbox.zip .
cd -

cp README.md build/package/README.md
cp LICENSE build/package/LICENSE

zip -r build/package/source-code.zip .

cd examples
zip -r ../build/package/examples.zip .
cd -

# extract source code as idependent file
cp build/package/source-code.zip build/lift-ppl-source-code.zip

rm build/lift-ppl.zip
cd build/package
zip -r ../lift-ppl.zip .
cd -



