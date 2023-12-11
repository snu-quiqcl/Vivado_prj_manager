CC=C:\Program Files\LLVM\bin\clang.exe

TARGET=output.elf

LL_FILE=output.ll

S_FILE=startup.S

GCCFLAGS+=-c

CFLAGS=-O2
CFLAGS+=-Wall
CFLAGS+=--target=aarch64
CFLAGS+=-mcpu=cortex-a53

# Assuming that startup.o and other .o files are already compiled
# and you don't need to compile .c or .cpp files in this Makefile

LINKER_SCRIPT="C:\Jeonghyun\GIT\Vivado_prj_manager\Compiler\PythonCode\output\linker.ld"

LDFLAGS=-Wl,-T -Wl,$(LINKER_SCRIPT)

# Object files including the .ll file
OBJ_FILES += $(S_FILE:.S=.o)

# Build rule
all: $(TARGET)

# Rule to compile .ll to .o

%.o: %.S
	$(CC) $(GCCFLAGS) $< -o $@

$(TARGET): $(OBJ_FILES)
	$(CC) $(LDFLAGS)  -o $(TARGET) $(CFLAGS) $(OBJ_FILES) $(LL_FILE)

# Clean rule
clean:
	rm -f $(TARGET) $(OBJ_FILES)

