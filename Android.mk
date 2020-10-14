LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := CCloader
LOCAL_SRC_FILES := cold_clear_wrapper.c
LOCAL_LDFLAGS := -L$(LOVE2D_LIB)/$(TARGET_ARCH_ABI) -lcold_clear -llove
LOCAL_C_INCLUDES := cold-clear/c-api
include $(BUILD_SHARED_LIBRARY)
