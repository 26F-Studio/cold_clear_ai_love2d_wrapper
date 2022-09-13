CC=gcc
CFLAGS=-I./include -I./cold-clear/c-api -O2 -DNDEBUG
LOVE_HOME=love
SYSROOT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk

# Android build
android: build/Android/armeabi-v7a/CCloader.so build/Android/arm64-v8a/CCloader.so
	echo "Targets built: build/Android/armeabi-v7a/CCloader.so build/Android/arm64-v8a/CCloader.so"

build/Android/%/CCloader.so:
	ndk-build NDK_PROJECT_PATH=. NDK_APPLICATION_MK=Application.mk APP_BUILD_SCRIPT=Android.mk APP_ABI=$* APP_PLATFORM=android-28 APP_OPTIM=release APP_STL=none MY_COLDCLEAR_STANDALONE=yes
	mkdir -p $(@D)
	cp libs/$*/CCloader.so $@

# iOS build
build/iOS/arm64/libCCloader.a: cold_clear_wrapper.c lib/arm64/libluajit.a build/iOS/arm64/libcold_clear.a
	$(CC) $(CFLAGS) -isysroot $(SYSROOT) -target arm64-apple-ios -framework Security -c cold_clear_wrapper.c -o libCCloader.o
	libtool -static -o build/iOS/arm64/libCCloader.a libCCloader.o

build/iOS/arm64/libcold_clear.a:
	cd cold-clear && cargo build -p c-api --release --target=aarch64-apple-ios
	mkdir -p build/iOS/arm64/ && cp cold-clear/target/aarch64-apple-ios/release/libcold_clear.a build/iOS/arm64/libcold_clear.a

# Linux build
build/Linux/x64/CCloader.so: cold_clear_wrapper.c build/Linux/x64/libcold_clear.a
	$(CC) $(CFLAGS) -shared cold_clear_wrapper.c -Lbuild/Linux/x64 -lcold_clear -llua5.1 -o $@
	rm build/Linux/x64/libcold_clear.a

build/Linux/x64/libcold_clear.%:
	cd cold-clear && cargo build -p c-api --release --target=x86_64-unknown-linux-gnu
	mkdir -p $(@D) && cp cold-clear/target/x86_64-unknown-linux-gnu/release/$(@F) $@

# macOS build
build/macOS/universal/CCloader.dylib: cold_clear_wrapper.c lib/universal/libluajit.a build/macOS/universal/libcold_clear.a
	$(CC) $(CFLAGS) -target x86_64-apple-macos -shared cold_clear_wrapper.c lib/universal/libluajit.a build/macOS/universal/libcold_clear.a -o CCloader_x64.dylib
	$(CC) $(CFLAGS) -target aarch64-apple-macos -shared cold_clear_wrapper.c lib/universal/libluajit.a build/macOS/universal/libcold_clear.a -o CCloader_arm64.dylib
	lipo -create CCloader_x64.dylib CCloader_arm64.dylib -output build/macOS/universal/CCloader.dylib

build/macOS/universal/libcold_clear.a:
	cd cold-clear && cargo build -p c-api --release --target=x86_64-apple-darwin
	cd cold-clear && cargo build -p c-api --release --target=aarch64-apple-darwin
	mkdir -p build/macOS/universal/ && lipo -create cold-clear/target/x86_64-apple-darwin/release/libcold_clear.a cold-clear/target/aarch64-apple-darwin/release/libcold_clear.a -output build/macOS/universal/libcold_clear.a

# Windows build
windows: build/Windows/x86/CCloader.dll build/Windows/x64/CCloader.dll
	echo "Targets built: build/Windows/x86/CCloader.dll build/Windows/x64/CCloader.dll"

build/Windows/x86/CCloader.dll: cold_clear_wrapper.c lib/x86/lua51.dll build/Windows/x86/cold_clear.dll
	$(CC) $(CFLAGS) -s -m32 -shared cold_clear_wrapper.c build/Windows/x86/cold_clear.dll lib/x86/lua51.dll -o build/Windows/x86/CCloader.dll

build/Windows/x64/CCloader.dll: cold_clear_wrapper.c lib/x64/lua51.dll build/Windows/x64/cold_clear.dll
	$(CC) $(CFLAGS) -s -shared cold_clear_wrapper.c build/Windows/x64/cold_clear.dll lib/x64/lua51.dll -o build/Windows/x64/CCloader.dll

build/Windows/x86/cold_clear.dll:
	cd cold-clear && cargo build -p c-api --release --target=i686-pc-windows-msvc
	mkdir -p build/Windows/x86/ && cp cold-clear/target/i686-pc-windows-msvc/release/cold_clear.dll build/Windows/x86/cold_clear.dll

build/Windows/x64/cold_clear.dll:
	cd cold-clear && cargo build -p c-api --release --target=x86_64-pc-windows-msvc
	mkdir -p build/Windows/x64/ && cp cold-clear/target/x86_64-pc-windows-msvc/release/cold_clear.dll build/Windows/x64/cold_clear.dll
