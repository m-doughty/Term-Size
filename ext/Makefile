UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
	SOEXT = dylib
	SHARED = -dynamiclib
else
	SOEXT = so
	SHARED = -shared -fPIC
endif

all:
	$(CC) $(SHARED) termsize.c -o libtermsize.$(SOEXT)
clean:
	rm -f libtermsize.so libtermsize.dylib

