CC=gcc
CFLAGS=-I./include -I./cold-clear/c-api -O2 -DNDEBUG
ANDROID_CC=path/to/arm-linux-androideabi-gcc

# window x64 build
CCloader.dll: cold_clear_wrapper.c
	$(CC) $(CFLAGS) -s -shared cold_clear_wrapper.c cold_clear.dll lua51.dll -o CCloader.dll

# windows x86 build
x86/CCloader.dll: cold_clear_wrapper.c
	$(CC) $(CFLAGS) -s -m32 -shared cold_clear_wrapper.c x86/cold_clear.dll x86/lua51.dll -o x86/CCloader.dll

# linux build
CCloader.so: cold_clear_wrapper.c libcold_clear.so
	$(CC) $(CFLAGS) -shared cold_clear_wrapper.c libcold_clear.so /usr/lib/x86_64-linux-gnu/libluajit-5.1.so.2 -o CCloader.so

# OS X build
CCloader.dylib: cold_clear_wrapper.c libcold_clear.a libluajit.a
	$(CC) $(CFLAGS) -shared cold_clear_wrapper.c libcold_clear.a libluajit.a -o CCloader.dylib

libcold_clear.so:
	cd cold-clear && cargo build -p c-api --release
	cp cold-clear/target/release/libcold_clear.so .

libcold_clear.a:
	cd cold-clear && cargo build -p c-api --release
	cp cold-clear/target/release/libcold_clear.a .

libluajit.a:
	echo Download love.app, and find love.app/Contents/Framework/Lua.framework/Versions/A/Lua, rename it to libluajit.a and put it here.
	false

# android build, !! valid but not recommended, please follow Readme.md !!
android/libCCloader.so:
	$(ANDROID_CC) $(CFLAGS) -shared cold_clear_wrapper.c libcold_clear.so liblove.so -o libCCloader.so
