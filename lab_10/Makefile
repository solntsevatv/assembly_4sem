CC=gcc
SRC=./src
INC=./inc
OUT=./out
SOURCES=$(wildcard $(SRC)/*.c)
OBJS=$(SOURCES:$(SRC)/%.c=$(OUT)/%.o)
INCS=$(wildcard $(INC)/*.h)
CFLAGS=-std=c99 -I$(INC)/ -masm=intel  -g3


TARGET=$(OUT)/main.out

.PHONY: build clean all

all: build
	$(TARGET)

build: $(OBJS) $(INCS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS)
	$(CC) -I$(INC)/ -S src/scalar_prod.c
	$(CC) -I$(INC)/ -S src/main.c

$(OUT)/%.o: $(SRC)/%.c $(OUT)
	$(CC) $(CFLAGS) -c $< -o $@

$(OUT):
	mkdir -p $(OUT)


clean:
	rm -f *.o
	rm -f *.out
	rm -rf $(OUT)