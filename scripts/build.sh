#!/bin/bash

read -e -p "Enter version to build:" VERSION

docker build . \
--progress=plain \
--build-arg VERSION=$VERSION \
-t jozefrebjak/freeradius:$VERSION