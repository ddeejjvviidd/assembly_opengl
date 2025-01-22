all:
	nasm -f elf64 -g assgl.asm
	ld assgl.o -o assgl.elf --dynamic-linker=/lib64/ld-linux-x86-64.so.2 -lglfw -lGL

run:
	./assgl.elf

#WAYLAND_DISPLAY=wayland-0 ./ponggame.elf

