# Copyright (C) 2017 The Unlegacy Android Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

LOCAL_PATH	:= $(call my-dir)
hwc_path	:= hwcomposer
grl_path	:= libgralloc
fxm_path	:= nvfxmath
inc_path	:= include
krh_path	:= kernel-headers

common_pb_blobs := \
	-L $(TARGET_OUT_VENDOR_SHARED_LIBRARIES) \
    -lnvos \
    -lnvrm \
    -lnvrm_graphics \
    -lnvddk_2d_v2

common_static_libs := libnvfxmath
common_shared_libs := \
	liblog \
	libcutils \
	libnvos \
	libnvrm \
	libnvrm_graphics \
	libnvddk_2d_v2

# Library NvFxMath
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/$(inc_path) \
	$(LOCAL_PATH)/$(fxm_path)
LOCAL_SRC_FILES := \
	$(fxm_path)/asincos.c \
	$(fxm_path)/sincos.c \
	$(fxm_path)/fxconv_arm.S
LOCAL_MODULE := libnvfxmath
include $(BUILD_STATIC_LIBRARY)

ifeq ($(TEGRA3_BUILD_HWCOMPOSER),true)
# Hardware Composer
# HAL module implemenation, not prelinked and stored in
# hw/<OVERLAY_HARDWARE_MODULE_ID>.<ro.product.board>.so
include $(CLEAR_VARS)
LOCAL_PRELINK_MODULE := false
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR_SHARED_LIBRARIES)/hw
LOCAL_LDFLAGS := $(common_pb_blobs)
LOCAL_STATIC_LIBRARIES := $(common_static_libs)
LOCAL_SHARED_LIBRARIES := \
	$(common_shared_libs) \
	libdl \
	libEGL \
	libhardware
LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/$(hwc_path) \
	$(LOCAL_PATH)/$(inc_path) \
	$(LOCAL_PATH)/$(grl_path) \
	$(LOCAL_PATH)/$(krh_path)
LOCAL_SRC_FILES := \
	$(hwc_path)/nvhwc.c \
	$(hwc_path)/nvhwc_legacy.c \
	$(hwc_path)/nvhwc_debug.c \
	$(hwc_path)/nvhwc_didim.c \
	$(hwc_path)/nvhwc_external.c \
	$(hwc_path)/nvfb.c \
	$(hwc_path)/nvfb_hdcp.c
LOCAL_CFLAGS := -DLOG_TAG=\"hwcomposer\"
LOCAL_CFLAGS += -DHWC_FORCE_COMPOSITING_ON_HDMI=0
LOCAL_CFLAGS += -DALLOW_VIDEO_SCALING=1
LOCAL_CFLAGS += -DNVCAP_VIDEO_ENABLED=0
LOCAL_CFLAGS += -DNVDPS_ENABLE=0
# This config can be used to reduce memory usage at the cost of performance.
ifeq ($(BOARD_DISABLE_TRIPLE_BUFFERED_DISPLAY_SURFACES),true)
    LOCAL_CFLAGS += -DNVGR_USE_TRIPLE_BUFFERING=0
else
    LOCAL_CFLAGS += -DNVGR_USE_TRIPLE_BUFFERING=1
endif

LOCAL_MODULE := hwcomposer.tegra3
include $(BUILD_SHARED_LIBRARY)
endif

ifeq ($(TEGRA3_BUILD_GRALLOC),true)
# Graphics Memory Allocator
# HAL module implemenation, not prelinked and stored in
# hw/<OVERLAY_HARDWARE_MODULE_ID>.<ro.product.board>.so
include $(CLEAR_VARS)
LOCAL_PRELINK_MODULE := false
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR_SHARED_LIBRARIES)/hw
LOCAL_LDFLAGS := $(common_pb_blobs)
LOCAL_STATIC_LIBRARIES := $(common_static_libs)
LOCAL_SHARED_LIBRARIES := \
	 $(common_shared_libs) \
	libhardware_legacy
LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/$(inc_path) \
	$(LOCAL_PATH)/$(grl_path) \
	$(LOCAL_PATH)/$(krh_path)
LOCAL_SRC_FILES := \
	$(grl_path)/nvgrmodule.c \
	$(grl_path)/nvgralloc.c \
	$(grl_path)/nvgrbuffer.c \
	$(grl_path)/nvgr_scratch.c \
	$(grl_path)/nvgr_2d.c
LOCAL_CFLAGS += -DLOG_TAG=\"gralloc\"
LOCAL_CFLAGS += -DSUPPORT_MHL_CTS=0
LOCAL_CFLAGS += -DNVGR_DEBUG_LOCKS=0
LOCAL_CFLAGS += -DNVGR_ENABLE_TRACE=1
# This config can be used to reduce memory usage at the cost of performance.
ifeq ($(BOARD_DISABLE_TRIPLE_BUFFERED_DISPLAY_SURFACES),true)
    LOCAL_CFLAGS += -DNVGR_USE_TRIPLE_BUFFERING=0
else
    LOCAL_CFLAGS += -DNVGR_USE_TRIPLE_BUFFERING=1
endif
FB_IMPL :=
LOCAL_MODULE := gralloc.tegra3
include $(BUILD_SHARED_LIBRARY)
endif
