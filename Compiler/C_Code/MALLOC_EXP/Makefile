
# Define the compiler and compiler flags
CC = aarch64-none-elf-gcc
CFLAGS = -march=armv8-a -mcpu=cortex-a53 -nostartfiles -I ../include

# Define the linker and linker flags
LD = aarch64-none-elf-gcc
LDFLAGS = -march=armv8-a -mcpu=cortex-a53 -nostartfiles -T MALLOC_EXP.ld  -I ../include
ADD_LIB =../lib/libxil.a

# List all source files (cpp files) in the current folder
SRCS := $(wildcard *.c *.cpp)

# List all assembly files in the current folder
ASMS := ../init/startup.S

# List all object files corresponding to the source files
OBJS = $(SRCS:.c=.o) $(ASMS:.S=.o)

# Define the final target executable
TARGET = MALLOC_EXP.elf

# Default rule: build the executable
all: $(TARGET)

# Rule to compile each source file into object files
%.o: %.cpp
	$(CC) $(CFLAGS) -c $< $(ADD_LIB) -o $@

# Rule to compile each source file into object files2
%.o: %.c
	$(CC) $(CFLAGS) -c $< $(ADD_LIB) -o $@

# Rule to assemble each assembly source file into object files
%.o: %.S
	$(CC) $(CFLAGS) -c $< -o $@

# Rule to build the target executable
$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^ $(ADD_LIB)

# Clean rule: remove generated files
clean:
	del MALLOC_EXP.elf
	del $(OBJS)
	del $(TARGET)

#print all dirs
get-dir:
	$(ALL_DIRS)
                