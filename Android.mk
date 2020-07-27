LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := test
LOCAL_SRC_FILES := test.c
LOCAL_LDFLAGS := -Lpath/to/$(TARGET_ARCH_ABI) -llove
LOCAL_C_INCLUDES := include
include $(BUILD_SHARED_LIBRARY)
