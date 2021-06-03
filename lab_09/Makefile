CC=gcc
SRC=./src
INC=./inc
OUT=./out
SOURCES=$(wildcard $(SRC)/*.c)
OBJS=$(SOURCES:$(SRC)/%.c=$(OUT)/%.o)
INCS=$(wildcard $(INC)/*.h)
CFLAGS=-std=c99 -I$(INC)/ -masm=intel

FPU_INST_FRST=-M80387
FPU_INST_SEC=-MNO-80387

TARGET=$(OUT)/main.out
TARGET_MNO_80387=$(OUT)/main_mno-80387.out
TARGET_M_80387=$(OUT)/main_m80387.out

.PHONY: build clean run run_m run_mno

run: build
	$(TARGET)
run_m: build_m
	$(TARGET_M_80387)
run_mno: build_mno
	$(TARGET_MNO_80387)

build: $(OBJS) $(INCS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS)
build_m : CFLAGS += -m80387
build_m: $(OBJS) $(INCS)
	$(CC) $(CFLAGS) -o $(TARGET_M_80387) $(OBJS)
	$(CC) -I$(INC)/ -S src/32_bit_processing.c
	$(CC) -I$(INC)/ -S src/64_bit_processing.c
	$(CC) -I$(INC)/ -S src/80_bit_processing.c

build_mno : CFLAGS += -mno-80387 -DX87
build_mno: $(OBJS) $(INCS)
	$(CC) $(CFLAGS) -o $(TARGET_MNO_80387) $(OBJS)
	$(CC) -I$(INC)/ -S src/32_bit_processing.c
	$(CC) -I$(INC)/ -S src/64_bit_processing.c
	$(CC) -I$(INC)/ -S src/80_bit_processing.c


$(OUT)/%.o: $(SRC)/%.c $(OUT)
	$(CC) $(CFLAGS) -c $< -o $@

$(OUT):
	mkdir -p $(OUT)


clean:
	rm -f *.o
	rm -f *.s
	rm -f *.out
	rm -rf $(OUT)