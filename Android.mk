LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := CCloader
LOCAL_MODULE_FILENAME := CCloader

$(LOCAL_PATH)/libcold_clear.a:
	cd cold-clear && cargo ndk -t $(TARGET_ARCH_ABI) --platform 24 build -p c-api --release
	cp cold-clear/target/*/$(@F) $@
	cd cold-clear && cargo clean
.INTERMEDIATE: $(LOCAL_PATH)/libcold_clear.a

LOCAL_SRC_FILES := cold_clear_wrapper.c libcold_clear.a
LOCAL_LDFLAGS := -L$(LOVE2D_LIB)/$(TARGET_ARCH_ABI) -llove -Wl,--hash-style=both
LOCAL_C_INCLUDES := include cold-clear/c-api
include $(BUILD_SHARED_LIBRARY)
