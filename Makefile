CC=gcc
CFLAGS=-I./include -I./cold-clear/c-api -O2 -DNDEBUG
LOVE_HOME=love

# Android build
android: build/armeabi-v7a/libCCloader.so build/arm64-v8a/libCCloader.so
	echo "Targets built: build/armeabi-v7a/libCCloader.so build/arm64-v8a/libCCloader.so"

build/armeabi-v7a/libCCloader.so: build/armeabi-v7a/libcold_clear.so
	cp build/armeabi-v7a/libcold_clear.so $(LOVE_HOME)/lib/armeabi-v7a/
	ndk-build LOVE2D_LIB=$(LOVE_HOME)/lib
	cp libs/armeabi-v7a/libCCloader.so build/armeabi-v7a/libCCloader.so

build/arm64-v8a/libCCloader.so: build/arm64-v8a/libcold_clear.so
	cp build/arm64-v8a/libcold_clear.so $(LOVE_HOME)/lib/arm64-v8a/
	ndk-build LOVE2D_LIB=$(LOVE_HOME)/lib
	cp libs/arm64-v8a/libCCloader.so build/arm64-v8a/libCCloader.so

build/armeabi-v7a/libcold_clear.so:
	cd cold-clear && cargo ndk --target=armv7-linux-android --platform 21 build -p c-api --release
	mkdir -p build/armeabi-v7a/
        cp cold-clear/target/armv7-linux-android/release/libcold_clear.so build/armeabi-v7a/libcold_clear.so

build/arm64-v8a/libcold_clear.so:
	cd cold-clear && cargo ndk --target=aarch64-linux-android --platform 21 build -p c-api --release
	mkdir -p build/arm64-v8a/
        cp cold-clear/target/aarch64-linux-android/release/libcold_clear.so build/arm64-v8a/libcold_clear.so

# Windows build
windows: build/x86/CCloader.dll build/x64/CCloader.dll
	echo "Targets built: build/x86/CCloader.dll build/x64/CCloader.dll"

build/x86/CCloader.dll: cold_clear_wrapper.c lib/x86/lua51.dll build/x86/cold_clear.dll
	$(CC) $(CFLAGS) -s -m32 -shared cold_clear_wrapper.c build/x86/cold_clear.dll lib/x86/lua51.dll -o build/x86/CCloader.dll

build/x64/CCloader.dll: cold_clear_wrapper.c lib/x64/lua51.dll build/x64/cold_clear.dll
	$(CC) $(CFLAGS) -s -shared cold_clear_wrapper.c build/x64/cold_clear.dll lib/x64/lua51.dll -o build/x64/CCloader.dll

build/x86/cold_clear.dll:
	cd cold-clear && cargo build -p c-api --release --target=i686-pc-windows-msvc
	mkdir -p build/x86/
        cp cold-clear/target/i686-pc-windows-msvc/release/cold_clear.dll build/x86/cold_clear.dll

build/x64/cold_clear.dll:
	cd cold-clear && cargo build -p c-api --release --target=x86_64-pc-windows-msvc
	mkdir -p build/x64/
        cp cold-clear/target/x86_64-pc-windows-msvc/release/cold_clear.dll build/x64/cold_clear.dll

# Linux build
build/x64/CCloader.so: cold_clear_wrapper.c /usr/lib/x86_64-linux-gnu/libluajit-5.1.so.2 build/x64/libcold_clear.so
	$(CC) $(CFLAGS) -shared cold_clear_wrapper.c build/x64/libcold_clear.so /usr/lib/x86_64-linux-gnu/libluajit-5.1.so.2 -o build/x64/CCloader.so

build/x64/libcold_clear.so:
	cd cold-clear && cargo build -p c-api --release --target=x86_64-unknown-linux-gnu
	mkdir -p build/x64/
        cp cold-clear/target/x86_64-unknown-linux-gnu/release/libcold_clear.so build/x64/libcold_clear.so

# macOS build
build/universal/CCloader.dylib: cold_clear_wrapper.c lib/universal/libluajit.a build/universal/libcold_clear.a
	$(CC) $(CFLAGS) -shared cold_clear_wrapper.c lib/universal/libluajit.a build/universal/libcold_clear.a -o build/universal/CCloader.dylib

build/universal/libcold_clear.a:
	cd cold-clear && cargo build -p c-api --release --target=x86_64-apple-darwin
	cd cold-clear && cargo build -p c-api --release --target=aarch64-apple-darwin
	mkdir -p build/universal/
        lipo -create cold-clear/target/x86_64-apple-darwin/release/libcold_clear.a cold-clear/target/aarch64-apple-darwin/release/libcold_clear.a -output build/universal/libcold_clear.a

# iOS build
build/universal/libCCloader.a: cold_clear_wrapper.c lib/x64/libluajit.a lib/arm64/libluajit.a build/x64/libcold_clear.a build/arm64/libcold_clear.a
	$(CC) $(CFLAGS) -shared cold_clear_wrapper.c lib/x64/libluajit.a build/x64/libcold_clear.a -o build/x64/libCCloader.a
	$(CC) $(CFLAGS) -shared cold_clear_wrapper.c lib/arm64/libluajit.a build/arm64/libcold_clear.a -o build/arm64/libCCloader.a
	mkdir -p build/universal/
        lipo -create build/x64/libCCloader.a build/arm64/libCCloader.a -output build/universal/libCCloader.a

build/x64/libcold_clear.a:
	cd cold-clear && cargo build -p c-api --release --target=x86_64-apple-ios
	mkdir -p build/x64/
	cp cold-clear/target/x86_64-apple-ios/release/libcold_clear.a build/x64/libcold_clear.a

build/arm64/libcold_clear.a:
	cd cold-clear && cargo build -p c-api --release --target=aarch64-apple-ios
	mkdir -p build/arm64/
	cp cold-clear/target/aarch64-apple-ios/release/libcold_clear.a build/arm64/libcold_clear.a
