qemu: mostrar
	qemu-system-x86_64 --drive file=main.img,format=raw,media=disk
	
mostrar: a.o main.img
	objdump -S a.o
	hd main.img
	
a.o: a.S
	as -o a.o a.S
	
main.img:
	printf '\364%509s\125\252' > main.img
	
a.S:
	echo hlt > a.S
	
clean:
	rm *.o *.img *.S
