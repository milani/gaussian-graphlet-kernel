UNAME = $(shell uname -s)
CC = clang++
ifeq ($(UNAME),Linux)
	CC = g++
endif
CFLAGS = -O2 -std=c++11

ggk: ggk.cpp
	$(CC) $(CFLAGS) -o $@ $^

.PHONY: clean ggk
clean:
	rm -f ggk ggk.o
