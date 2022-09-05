LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := CCloader
LOCAL_MODULE_FILENAME := CCloader
LOCAL_SRC_FILES := cold_clear_wrapper.c
LOCAL_LDFLAGS := $(LOVE2D_LIB)/$(TARGET_ARCH_ABI)/libcold_clear.a -L$(LOVE2D_LIB)/$(TARGET_ARCH_ABI) -llove -Wl,--hash-style=both
LOCAL_C_INCLUDES := include cold-clear/c-api
include $(BUILD_SHARED_LIBRARY)
