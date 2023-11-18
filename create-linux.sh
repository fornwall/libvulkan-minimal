#!/bin/sh
set -e -u

VULKAN_SDK_VERSION=1.3.268.0
VULKAN_SDK_URL=https://sdk.lunarg.com/sdk/download/${VULKAN_SDK_VERSION}/linux/vulkansdk-linux-x86_64-${VULKAN_SDK_VERSION}.tar.xz

curl -O $VULKAN_SDK_URL
