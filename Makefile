CFLAGS=-I ./include -s -O2 -DNDEBUG

CCloader.dll: cold_clear_wrapper.c
	gcc $(CFLAGS) -shared cold_clear_wrapper.c cold_clear.dll lua51.dll -o CCloader.dll

cold_clear_wrapper.dll: cold_clear_wrapper.c
	gcc $(CFLAGS) -shared cold_clear_wrapper.c cold_clear.dll lua51.dll -o cold_clear_wrapper.dll

a.exe: test.c
	gcc $(CFLAGS) test.c cold_clear.dll
