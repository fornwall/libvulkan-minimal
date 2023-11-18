#!/bin/bash
set -e -u

VULKAN_SDK_MAC_VERSION=1.3.268.1
VULKAN_SDK_DMGNAME=vulkansdk-macos-${VULKAN_SDK_MAC_VERSION}.dmg
VULKAN_SDK_MINIMAL_DIRNAME=vulkansdk-macos-minimal-x86_64-${VULKAN_SDK_MAC_VERSION}
VULKAN_SDK_URL=https://sdk.lunarg.com/sdk/download/${VULKAN_SDK_MAC_VERSION}/mac/$VULKAN_SDK_DMGNAME

curl -L -O $VULKAN_SDK_URL

7zz x $VULKAN_SDK_DMGNAME

# See https://vulkan.lunarg.com/doc/sdk/latest/mac/getting_started.html
# Remove .app suffix to not get error about damaged file:
mv InstallVulkan.app InstallVulkan

./InstallVulkan/Contents/MacOS/InstallVulkan --root $PWD/$VULKAN_SDK_MAC_VERSION --accept-licenses --default-answer --confirm-command install com.lunarg.vulkan.core

mv $VULKAN_SDK_MAC_VERSION $VULKAN_SDK_MAC_VERSION-full

mkdir -p $VULKAN_SDK_MAC_VERSION/macOS/lib/

cp $VULKAN_SDK_MAC_VERSION-full/macOS/lib/libVkLayer_khronos_validation.dylib $VULKAN_SDK_MAC_VERSION/macOS/lib/libVkLayer_khronos_validation.dylib 

mv "$VULKAN_SDK_MAC_VERSION" "$VULKAN_SDK_MINIMAL_DIRNAME"
