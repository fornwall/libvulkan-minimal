#!/bin/bash
set -e -u

. sdk-version.sh

VULKAN_SDK_TARNAME=vulkansdk-linux-x86_64-${VULKAN_SDK_VERSION}.tar.xz
VULKAN_SDK_MINIMAL_DIRECTORY=vulkansdk-linux-minimal-x86_64
VULKAN_SDK_MINIMAL_TARNAME=${VULKAN_SDK_MINIMAL_DIRECTORY}.tar.xz
VULKAN_SDK_URL=https://sdk.lunarg.com/sdk/download/${VULKAN_SDK_VERSION}/linux/$VULKAN_SDK_TARNAME

curl -O "$VULKAN_SDK_URL"

tar xf "$VULKAN_SDK_TARNAME"

mv "$VULKAN_SDK_VERSION" "$VULKAN_SDK_VERSION"-full

mkdir -p "$VULKAN_SDK_MINIMAL_DIRECTORY"/{include,lib,share/vulkan/explicit_layer.d}
cp -Rf "$VULKAN_SDK_VERSION"-full/x86_64/include/* "$VULKAN_SDK_MINIMAL_DIRECTORY"/include/
cp -Rf "$VULKAN_SDK_VERSION"-full/x86_64/share/vulkan/explicit_layer.d/* "$VULKAN_SDK_MINIMAL_DIRECTORY"/share/vulkan/explicit_layer.d/
cp "$VULKAN_SDK_VERSION"-full/x86_64/lib/{libvulkan*,libVkLayer_khronos_validation.so} "$VULKAN_SDK_MINIMAL_DIRECTORY"/lib/

# Shrink from around 600 MB to 40:
strip "$VULKAN_SDK_MINIMAL_DIRECTORY"/lib/libVkLayer_khronos_validation.so

tar cf $VULKAN_SDK_MINIMAL_TARNAME $VULKAN_SDK_MINIMAL_DIRECTORY
