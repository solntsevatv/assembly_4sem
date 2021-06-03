CC := gcc
CFLAGS := -std=c99 -Wall -Werror
AC := nasm
AFLAGS := -felf64

app.exe: strcopy.o main.o
	gcc -o app.exe $^
	gcc -S main.c

strcopy.o: strcopy.asm
	$(AC) $(AFLAGS) $< -o $@

main.o: main.c
	$(CC) $(CGLAGS) -c $<

clean:
	-rm *.o *.exe *.s
	@ls