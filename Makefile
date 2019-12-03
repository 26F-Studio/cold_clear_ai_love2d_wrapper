CFLAGS=-I ./include -s -O2 -DNDEBUG

cold_clear_wrapper.dll: cold_clear_wrapper.c
	gcc $(CFLAGS) -shared cold_clear_wrapper.c lua51.dll -o cold_clear_wrapper.dll
