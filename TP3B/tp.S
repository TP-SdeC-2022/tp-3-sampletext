comienzo: 
    .code16						/*bloque de instrucciones de 16 bits*/
    cli						/*limpiar interrupciones*/		
    .equ CODE_SEG, 8					/*code_seg = 8d*/
    .equ DATA_SEG, gdt_data - gdt_start		/*data_seg = 16 - 0*/
    lgdt gdt_descriptor				/*carga el registro que apunta a la tabla global con gdt_descriptor*/					
    mov %cr0, %eax					/*  */
    orl $0x1, %eax					/*  */
    mov %eax, %cr0					/*pongo en 1 el bit 0 (protected enable) del cr0 para entrar en modo protegido*/
    ljmp $CODE_SEG, $protected_mode			/*salta al bloque de código "protected_mode" de 32 bits (línea 37) y carga en el code_segment el valor de CODE_SEG (8)*/ 
    
gdt_start:						
gdt_null:						/*primer descriptor de segmento de la gdt (descriptor nulo)*/
    .long 0x0
    .long 0x0
gdt_code:						/*segundo descriptor de la gdt (segmento de código)*/
    .word 0xffff					/*donde termina el segmento (límite)*/
    .word 0x0						/*donde arranca el segmento (base)*/
    .byte 0x0
    .byte 0b10011010
    .byte 0b11001111
    .byte 0x0
gdt_data:						/*tercer descriptor de la gdt (segmento de datos)*/
    .word 0xffff					/*donde termina el segmento (límite)*/
    .word 0x0						/*donde arranca el segmento (base)*/
    .byte 0x0
    .byte 0b10010010
    .byte 0b11001111
    .byte 0x0
gdt_end:						/*fin de la gdt*/
gdt_descriptor:					/*descriptor de la gdt*/
    .word gdt_end - gdt_start				/*donde termina la tabla (límite)*/
    .long gdt_start					/*donde arranca la tabla (base)*/
vga_current_line:					/*imprimir cuando estamos en modo protegido sin BIOS*/
    .long 0
.code32
protected_mode:
    mov $DATA_SEG, %ax					/*cargo valor de DATA_SEG en todos los registros de segmento que no sean de código (cs)*/
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss

    mov $0X7000, %ebp
    mov %ebp, %esp

        mov $print, %ecx
        mov vga_current_line, %eax
        mov $0, %edx
        mov $25, %ebx                   
        div %ebx
        mov %edx, %eax
        mov $160, %edx                  
        mul %edx
        lea 0xb8000(%eax), %edx         
        mov $0x0f, %ah                  
    loop:
        mov (%ecx), %al
        cmp $0, %al
        je end
        mov %ax, (%edx)
        add $1, %ecx
        add $2, %edx
        jmp loop
    end:
        hlt

    print:
        .asciz "TRABAJO PRACTICO SISTEMAS DE COMPUTACION 3"
    

