all:
	nasm -f elf64 -g ponggame.asm
	ld ponggame.o -o ponggame.elf --dynamic-linker=/lib64/ld-linux-x86-64.so.2 -lglfw -lGL

run:
	SDL_VIDEODRIVER=wayland ./ponggame.elf

#WAYLAND_DISPLAY=wayland-0 ./ponggame.elf

