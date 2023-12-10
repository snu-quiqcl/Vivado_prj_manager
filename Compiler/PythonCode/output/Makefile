CC=clang
GCC=aarch64-none-elf-gcc

TARGET=output.elf

LL_FILE=output.ll

S_FILE=startup.S

GCCFLAGS=-Wall
GCCFLAGS+=-O2
GCCFLAGS+=-c
GCCFLAGS+=-fmessage-length=0

CFLAGS=-O2
CFLAGS+=-Wall
CFLAGS+=--target=aarch64
CFLAGS+=-mcpu=cortex-a53
CFLAGS+=-c

# Assuming that startup.o and other .o files are already compiled
# and you don't need to compile .c or .cpp files in this Makefile

LINKER_SCRIPT=linker.ld

LDFLAGS=-T $(LINKER_SCRIPT)

# Object files including the .ll file
OBJ_FILES += $(S_FILE:.S=.o)

# Build rule
all: $(TARGET)

# Rule to compile .ll to .o

%.o: %.S
	$(GCC) $(GCCFLAGS) $< -o $@

$(TARGET): $(OBJ_FILES)
	$(CC) $(CFLAGS) $(OBJ_FILES) $(LL_FILE) -o $(TARGET) $(LDFLAGS)

# Clean rule
clean:
	rm -f $(TARGET) $(OBJ_FILES)

