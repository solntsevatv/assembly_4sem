TARGETS=tooltip

ASM=/usr/bin/nasm
LD=/usr/bin/ld
ASMOPTS=-felf64
LDOPTS=-m elf_x86_64 -lc --dynamic-linker /lib64/ld-linux-x86-64.so.2
LDOPTS2=-felf_x86_64 -lc 
LIBS= `pkg-config --libs gtk+-3.0`

.PHONY: all clean main

all: $(TARGETS)

# main: 
# 	gcc `pkg-config --cflags --libs gtk+-3.0` -I/usr/include/gtk-3.0 -g3 -Wall -c main.c -o $(LDOPTS2) app.exe
# 	chmod +x app.exe
# 	./app.exe

clean:
	rm -f $(TARGETS) *.o

%: %.asm
	$(ASM) -g $(ASMOPTS) -o $@.o $<
	$(LD) -o $@ $(LDOPTS) $@.o $(LIBS)
