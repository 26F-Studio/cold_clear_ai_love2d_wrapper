CC=gcc
CFLAGS=-I./include -I./cold-clear/c-api -O2 -DNDEBUG
LOVE_HOME=love
SYSROOT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk

# Android build
android: build/armeabi-v7a/libCCloader.so build/arm64-v8a/libCCloader.so
	echo "Targets built: build/armeabi-v7a/libCCloader.so build/arm64-v8a/libCCloader.so"

build/%/libCCloader.so: build/%/libcold_clear.a
	cp $^ $(LOVE_HOME)/lib/$*/
	ndk-build NDK_PROJECT_PATH=. NDK_APPLICATION_MK=Application.mk APP_BUILD_SCRIPT=Android.mk LOVE2D_LIB=$(LOVE_HOME)/lib APP_ABI=$*
	cp libs/$*/libCCloader.so build/$*/libCCloader.so

build/armeabi-v7a/libcold_clear.%:
	cd cold-clear && cargo ndk -t armeabi-v7a --platform 24 build -p c-api --release
	mkdir -p build/armeabi-v7a/ && cp cold-clear/target/armv7-linux-androideabi/release/$@ build/armeabi-v7a/

build/arm64-v8a/libcold_clear.%:
	cd cold-clear && cargo ndk -t arm64-v8a --platform 24 build -p c-api --release
	mkdir -p build/arm64-v8a/ && cp cold-clear/target/aarch64-linux-android/release/$@ build/arm64-v8a/

# iOS build
build/arm64/libCCloader.a: cold_clear_wrapper.c lib/arm64/libluajit.a build/arm64/libcold_clear.a
	$(CC) $(CFLAGS) -isysroot $(SYSROOT) -target arm64-apple-ios -framework Security -c cold_clear_wrapper.c -o libCCloader.o
	libtool -static -o build/arm64/libCCloader.a libCCloader.o

build/arm64/libcold_clear.a:
	cd cold-clear && cargo build -p c-api --release --target=aarch64-apple-ios
	mkdir -p build/arm64/ && cp cold-clear/target/aarch64-apple-ios/release/libcold_clear.a build/arm64/libcold_clear.a

# Linux build
build/x64/CCloader.so: cold_clear_wrapper.c /usr/lib/x86_64-linux-gnu/libluajit-5.1.so.2 build/x64/libcold_clear.so
	$(CC) $(CFLAGS) -shared cold_clear_wrapper.c build/x64/libcold_clear.so /usr/lib/x86_64-linux-gnu/libluajit-5.1.so.2 -o build/x64/CCloader.so

build/x64/libcold_clear.so:
	cd cold-clear && cargo build -p c-api --release --target=x86_64-unknown-linux-gnu
	mkdir -p build/x64/ && cp cold-clear/target/x86_64-unknown-linux-gnu/release/libcold_clear.so build/x64/libcold_clear.so

# macOS build
build/universal/CCloader.dylib: cold_clear_wrapper.c lib/universal/libluajit.a build/universal/libcold_clear.a
	$(CC) $(CFLAGS) -target x86_64-apple-macos -shared cold_clear_wrapper.c lib/universal/libluajit.a build/universal/libcold_clear.a -o CCloader_x64.dylib
	$(CC) $(CFLAGS) -target aarch64-apple-macos -shared cold_clear_wrapper.c lib/universal/libluajit.a build/universal/libcold_clear.a -o CCloader_arm64.dylib
	lipo -create CCloader_x64.dylib CCloader_arm64.dylib -output build/universal/CCloader.dylib

build/universal/libcold_clear.a:
	cd cold-clear && cargo build -p c-api --release --target=x86_64-apple-darwin
	cd cold-clear && cargo build -p c-api --release --target=aarch64-apple-darwin
	mkdir -p build/universal/ && lipo -create cold-clear/target/x86_64-apple-darwin/release/libcold_clear.a cold-clear/target/aarch64-apple-darwin/release/libcold_clear.a -output build/universal/libcold_clear.a

# Windows build
windows: build/x86/CCloader.dll build/x64/CCloader.dll
	echo "Targets built: build/x86/CCloader.dll build/x64/CCloader.dll"

build/x86/CCloader.dll: cold_clear_wrapper.c lib/x86/lua51.dll build/x86/cold_clear.dll
	$(CC) $(CFLAGS) -s -m32 -shared cold_clear_wrapper.c build/x86/cold_clear.dll lib/x86/lua51.dll -o build/x86/CCloader.dll

build/x64/CCloader.dll: cold_clear_wrapper.c lib/x64/lua51.dll build/x64/cold_clear.dll
	$(CC) $(CFLAGS) -s -shared cold_clear_wrapper.c build/x64/cold_clear.dll lib/x64/lua51.dll -o build/x64/CCloader.dll

build/x86/cold_clear.dll:
	cd cold-clear && cargo build -p c-api --release --target=i686-pc-windows-msvc
	mkdir -p build/x86/ && cp cold-clear/target/i686-pc-windows-msvc/release/cold_clear.dll build/x86/cold_clear.dll

build/x64/cold_clear.dll:
	cd cold-clear && cargo build -p c-api --release --target=x86_64-pc-windows-msvc
	mkdir -p build/x64/ && cp cold-clear/target/x86_64-pc-windows-msvc/release/cold_clear.dll build/x64/cold_clear.dll
