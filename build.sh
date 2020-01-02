#!/bin/bash

major=$(cat version/MAJOR)
minor=$(cat version/MINOR)
patch=$(expr $(cat version/PATCH) + 1)
echo $patch >version/PATCH
build=$(git rev-list HEAD --count)

echo "major: $major"
echo "major: $minor"
echo "major: $patch"
echo "build: $build"

flutter build appbundle --target-platform android-arm,android-arm64,android-x64
