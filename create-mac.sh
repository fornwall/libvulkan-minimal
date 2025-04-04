#!/bin/bash
set -e -u

. sdk-version.sh
VULKAN_SDK_ZIPNAME=vulkansdk-macos-${VULKAN_SDK_VERSION}.zip
VULKAN_SDK_MINIMAL_DIRECTORY=vulkansdk-macos-minimal
VULKAN_SDK_MINIMAL_TARNAME=${VULKAN_SDK_MINIMAL_DIRECTORY}.tar.xz
VULKAN_SDK_URL=https://sdk.lunarg.com/sdk/download/${VULKAN_SDK_VERSION}/mac/$VULKAN_SDK_ZIPNAME

curl -L -O $VULKAN_SDK_URL

unzip $VULKAN_SDK_ZIPNAME

# See https://vulkan.lunarg.com/doc/sdk/latest/mac/getting_started.html
# Remove .app suffix to not get error about damaged file:
mv InstallVulkan-${VULKAN_SDK_VERSION}.app InstallVulkan

./InstallVulkan/Contents/MacOS/InstallVulkan-${VULKAN_SDK_VERSION} --root $PWD/$VULKAN_SDK_VERSION --accept-licenses --default-answer --confirm-command install com.lunarg.vulkan.core

mv $VULKAN_SDK_VERSION $VULKAN_SDK_VERSION-full

mkdir -p $VULKAN_SDK_MINIMAL_DIRECTORY/{lib/,include/,share/vulkan/explicit_layer.d,share/vulkan/icd.d}
lipo $VULKAN_SDK_VERSION-full/macOS/lib/MoltenVK.xcframework/macos-arm64_x86_64/libMoltenVK.a -thin arm64 -output $VULKAN_SDK_MINIMAL_DIRECTORY/lib/libMoltenVK.a
lipo "$VULKAN_SDK_VERSION"-full/macOS/lib/libMoltenVK.dylib -thin arm64 -output  "$VULKAN_SDK_MINIMAL_DIRECTORY"/lib/libMoltenVK.dylib
cp "$VULKAN_SDK_VERSION"-full/macOS/lib/{libvulkan*,libVkLayer*.dylib} "$VULKAN_SDK_MINIMAL_DIRECTORY"/lib/
cp -Rf $VULKAN_SDK_VERSION-full/macOS/include/* $VULKAN_SDK_MINIMAL_DIRECTORY/include/
cp -Rf $VULKAN_SDK_VERSION-full/macOS/share/vulkan/explicit_layer.d/* $VULKAN_SDK_MINIMAL_DIRECTORY/share/vulkan/explicit_layer.d/
cp -Rf $VULKAN_SDK_VERSION-full/macOS/share/vulkan/icd.d/* $VULKAN_SDK_MINIMAL_DIRECTORY/share/vulkan/icd.d/

tar cf $VULKAN_SDK_MINIMAL_TARNAME $VULKAN_SDK_MINIMAL_DIRECTORY
