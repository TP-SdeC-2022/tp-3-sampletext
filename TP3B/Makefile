qemu: main.img
	qemu-system-i386 -fda main.img -boot a -s -S -monitor stdio
	
main.img: tp.S
	as -g -o main.o tp.S
	ld --oformat binary -o main.img -T link.ld main.o
	
clean:
	rm *.o *.img
