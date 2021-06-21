TARGET = mecrisp-stellaris-stm32f051c8

AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OBJDUMP = arm-none-eabi-objdump
OBJCOPY = arm-none-eabi-objcopy
GDB = arm-none-eabi-gdb

ASFLAGS = --warn --fatal-warnings -g

SOURCES = $(TARGET).s flash.s interrupts.s terminal.s vectors.s

all : $(TARGET).bin $(TARGET).lst

$(TARGET).o : $(SOURCES)
	$(AS) $(ASFLAGS) $(TARGET).s -o $@

$(TARGET).elf : $(TARGET).ld $(TARGET).o
	$(LD) -o $(TARGET).elf -T $(TARGET).ld $(TARGET).o

$(TARGET).lst : $(TARGET).elf
	$(OBJDUMP) -D $(TARGET).elf > $(TARGET).lst

$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) $^ $@ -O binary

.PHONY: burn gdb clean

burn:
	st-flash erase
	st-flash write $(TARGET).bin 0x8000000

burn_u:
	stm32flash -w $(TARGET).bin -S 0x8000000 -b 115200 /dev/ttyUSB0

gdb:
	$(GDB) -ex "target remote :4242" -ex "monitor reset halt" $(TARGET).elf

clean:
	rm -f *.bin *.o *.elf *.lst
