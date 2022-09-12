MY_COLDCLEAR_LOCAL_PATH := $(call my-dir)
LOCAL_PATH := $(MY_COLDCLEAR_LOCAL_PATH)
include $(CLEAR_VARS)
LOCAL_MODULE := CCloader
LOCAL_MODULE_FILENAME := CCloader
CCNAME := cold_clear-$(TARGET_ARCH_ABI)

$(MY_COLDCLEAR_LOCAL_PATH)/$(CCNAME).c:
	cargo install cargo-ndk
	case $(TARGET_ARCH_ABI) in \
		armeabi-v7a) rustup target add armv7-linux-androideabi;; \
		arm64-v8a) rustup target add aarch64-linux-android;; \
		*) exit 1;; \
	esac
	cd $(@D)/cold-clear && cargo ndk -t $(TARGET_ARCH_ABI) --platform 24 build -p c-api --release
	cp $(@D)/cold-clear/target/*/release/libcold_clear.a $(@D)/lib$(CCNAME).a
	cd $(@D)/cold-clear && cargo clean
	touch $@
.PHONY: $(MY_COLDCLEAR_LOCAL_PATH)/$(CCNAME).c

LOCAL_SRC_FILES := cold_clear_wrapper.c $(CCNAME).c
LOCAL_LDFLAGS := $(MY_COLDCLEAR_LOCAL_PATH)/lib$(CCNAME).a -llove -Wl,--hash-style=both
LOCAL_C_INCLUDES := $(MY_COLDCLEAR_LOCAL_PATH)/include $(MY_COLDCLEAR_LOCAL_PATH)/cold-clear/c-api
include $(BUILD_SHARED_LIBRARY)
