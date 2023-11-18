#!/bin/bash
set -e -u

# VULKAN_SDK_LINUX_VERSION=1.3.268.0
VULKAN_SDK_TARNAME=vulkansdk-linux-x86_64-${VULKAN_SDK_LINUX_VERSION}.tar.xz
VULKAN_SDK_MINIMAL_TARNAME=vulkansdk-linux-minimal-x86_64-${VULKAN_SDK_LINUX_VERSION}.tar.xz
VULKAN_SDK_URL=https://sdk.lunarg.com/sdk/download/${VULKAN_SDK_LINUX_VERSION}/linux/$VULKAN_SDK_TARNAME

curl -O "$VULKAN_SDK_URL"

tar xf "$VULKAN_SDK_TARNAME"

mv "$VULKAN_SDK_LINUX_VERSION" "$VULKAN_SDK_LINUX_VERSION"-full

mkdir -p "$VULKAN_SDK_LINUX_VERSION"/x86_64/{include,lib}
cp -Rf "$VULKAN_SDK_LINUX_VERSION"-full/x86_64/include/* "$VULKAN_SDK_LINUX_VERSION"/x86_64/include/
cp "$VULKAN_SDK_LINUX_VERSION"-full/x86_64/lib/{libvulkan*,libVkLayer_khronos_validation.so} "$VULKAN_SDK_LINUX_VERSION"/x86_64/lib/

# Shrink from around 600 MB to 40:
strip "$VULKAN_SDK_LINUX_VERSION"/x86_64/lib/libVkLayer_khronos_validation.so

tar cf $VULKAN_SDK_MINIMAL_TARNAME $VULKAN_SDK_LINUX_VERSION
