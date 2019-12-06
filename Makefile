CFLAGS=-I ./include -s -O2 -DNDEBUG
ANDROID_CC=

CCloader.dll: cold_clear_wrapper.c
	gcc $(CFLAGS) -shared cold_clear_wrapper.c cold_clear.dll lua51.dll -o CCloader.dll

x86/CCloader.dll: cold_clear_wrapper.c
	gcc $(CFLAGS) -m32 -shared cold_clear_wrapper.c x86/cold_clear.dll x86/lua51.dll -o x86/CCloader.dll

CCloader.so:
	$(ANDROID_CC) $(CFLAGS) -shared cold_clear_wrapper.c libcold_clear.so liblove.so -o CCloader.so

# cold_clear_wrapper.dll: cold_clear_wrapper.c
# 	gcc $(CFLAGS) -shared cold_clear_wrapper.c cold_clear.dll lua51.dll -o cold_clear_wrapper.dll

a.exe: test.c
	gcc $(CFLAGS) test.c cold_clear.dll
