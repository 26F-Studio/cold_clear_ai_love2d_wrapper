LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := CCloader
LOCAL_SRC_FILES := cold_clear_wrapper.c
LOCAL_LDFLAGS := -L$(LOVE2D_LIB)/$(TARGET_ARCH_ABI) -Wl,--hash-style=both
LOCAL_STATIC_LIBRARIES := cold_clear
LOCAL_SHARED_LIBRARIES := love
LOCAL_C_INCLUDES := include cold-clear/c-api
include $(BUILD_SHARED_LIBRARY)
include $(BUILD_STATIC_LIBRARY)
