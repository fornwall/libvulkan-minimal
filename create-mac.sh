#!/bin/bash
set -e -u

VULKAN_SDK_MAC_VERSION=1.3.268.1
VULKAN_SDK_DMGNAME=vulkansdk-macos-${VULKAN_SDK_MAC_VERSION}.dmg
VULKAN_SDK_MINIMAL_TARNAME=vulkansdk-macos-minimal-${VULKAN_SDK_MAC_VERSION}.tar.xz
VULKAN_SDK_URL=https://sdk.lunarg.com/sdk/download/${VULKAN_SDK_MAC_VERSION}/mac/$VULKAN_SDK_DMGNAME

curl -L -O $VULKAN_SDK_URL

7zz x $VULKAN_SDK_DMGNAME

# See https://vulkan.lunarg.com/doc/sdk/latest/mac/getting_started.html
# Remove .app suffix to not get error about damaged file:
mv InstallVulkan.app InstallVulkan

./InstallVulkan/Contents/MacOS/InstallVulkan --root $PWD/$VULKAN_SDK_MAC_VERSION --accept-licenses --default-answer --confirm-command install com.lunarg.vulkan.core

mv $VULKAN_SDK_MAC_VERSION $VULKAN_SDK_MAC_VERSION-full

mkdir -p $VULKAN_SDK_MAC_VERSION/macOS/{lib/,include/,share/vulkan/explicit_layer.d}
lipo $VULKAN_SDK_MAC_VERSION-full/MoltenVK/MoltenVK.xcframework/macos-arm64_x86_64/libMoltenVK.a -thin arm64 -output $VULKAN_SDK_MAC_VERSION/macOS/lib/libMoltenVK.a
lipo "$VULKAN_SDK_MAC_VERSION"-full/MoltenVK/dylib/macOS/libMoltenVK.dylib -thin arm64 -output  "$VULKAN_SDK_MAC_VERSION"/macOS/lib/libMoltenVK.dylib
cp "$VULKAN_SDK_MAC_VERSION"-full/macOS/lib/{libvulkan*,libVkLayer*.dylib} "$VULKAN_SDK_MAC_VERSION"/macOS/lib/
cp -Rf $VULKAN_SDK_MAC_VERSION-full/macOS/include/* $VULKAN_SDK_MAC_VERSION/macOS/include/
cp -Rf $VULKAN_SDK_MAC_VERSION-full/macOS/share/vulkan/explicit_layer.d/* $VULKAN_SDK_MAC_VERSION/macOS/share/vulkan/explicit_layer.d/

tar cf $VULKAN_SDK_MINIMAL_TARNAME $VULKAN_SDK_MAC_VERSION
