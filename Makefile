bootdisk=disk.img
blocksize=512
disksize=100

boot1=boot1

# preencha esses valores para rodar o segundo estágio do bootloader
boot2=boot2
boot2pos=1
boot2size=1

# preencha esses valores para rodar o kernel
menu=menu
menupos=2
menusize=4

# preencha esses valores para rodar o kernel
kernel=kernel
kernelpos=6
kernelsize=8

file = $(bootdisk)

# adicionem os targets do kernel e do segundo estágio para usar o make all com eles

all: clean mydisk boot1 write_boot1 boot2 write_boot2 menu write_menu kernel write_kernel hexdump launchqemu

mydisk: 
	dd if=/dev/zero of=$(bootdisk) bs=$(blocksize) count=$(disksize) status=noxfer

boot1: 
	nasm -f bin $(boot1).asm -o $(boot1).bin 

boot2:
	nasm -f bin $(boot2).asm -o $(boot2).bin 

menu:
	nasm -f bin $(menu).asm -o $(menu).bin

kernel:
	nasm -f bin $(kernel).asm -o $(kernel).bin

write_boot1:
	dd if=$(boot1).bin of=$(bootdisk) bs=$(blocksize) count=1 conv=notrunc status=noxfer

write_boot2:
	dd if=$(boot2).bin of=$(bootdisk) bs=$(blocksize) seek=$(boot2pos) count=$(boot2size) conv=notrunc status=noxfer

write_menu:
	dd if=$(menu).bin of=$(bootdisk) bs=$(blocksize) seek=$(menupos) count=$(menusize) conv=notrunc

write_kernel:
	dd if=$(kernel).bin of=$(bootdisk) bs=$(blocksize) seek=$(kernelpos) count=$(kernelsize) conv=notrunc

hexdump:
	hexdump $(file)

disasm:
	ndisasm $(boot1).asm

launchqemu:
	qemu-system-i386 -fda $(bootdisk)
	
clean:
	rm -f *.bin $(bootdisk) *~
