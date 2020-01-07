#!/bin/bash

if [ ! -d version/ ]; then
    mkdir version
fi

if [ -f version/MAJOR ]; then
    major=$(cat version/MAJOR)
else
    major=0
fi

if [ -f version/MINOR ]; then
    minor=$(cat version/MINOR)
else
    minor=0
fi

if [ -f version/PATCH ]; then
    patch=$(cat version/PATCH)
else
    patch=0
fi

if [ -f version/BUILD ]; then
    build=$(cat version/BUILD)
else
    build=0
fi

minor=$(cat version/MINOR)
patch=$(expr $(cat version/PATCH) + 1)
echo $patch >version/PATCH
echo $major >version/MAJOR
echo $minor >version/MINOR
build=$(git rev-list HEAD --count)
echo $build >version/BUILD

echo "major: $major"
echo "major: $minor"
echo "major: $patch"
echo "build: $build"

flutter pub get

flutter clean

flutter build apk --build-name=$major.$minor.$patch --build-number=$build

flutter build appbundle --target-platform android-arm,android-arm64,android-x64 --build-name=$major.$minor.$patch --build-number=$build

echo "build: $major.$minor.$patch+$build"
