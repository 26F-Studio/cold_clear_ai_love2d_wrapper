LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := CCloader
LOCAL_MODULE_FILENAME := CCloader
CCNAME := cold_clear-$(TARGET_ARCH_ABI)

$(LOCAL_PATH)/$(CCNAME).c
	cd cold-clear && cargo ndk -t $(TARGET_ARCH_ABI) --platform 24 build -p c-api --release
	cp cold-clear/target/*/libcold_clear.a lib$(CCNAME).a
	cd cold-clear && cargo clean
	touch $@
.PHONY: $(LOCAL_PATH)/$(CCNAME).c

LOCAL_SRC_FILES := cold_clear_wrapper.c $(CCNAME).c
LOCAL_LDFLAGS := -l$(CCNAME) -L$(LOVE2D_LIB)/$(TARGET_ARCH_ABI) -llove -Wl,--hash-style=both
LOCAL_C_INCLUDES := include cold-clear/c-api
include $(BUILD_SHARED_LIBRARY)
