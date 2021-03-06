; Constants
    my_number_fromstudents_registry equ 22
	
	; 0xbe00 = 7c00h + 3 * 256 * my_number_fromstudents_registry
    kernel_memory_address equ 0xbe00

ORG kernel_memory_address

; The first byte of this instruction is 0x90.
; It is used by the loader to determine if we had a sucessful launch or not.
; This is known as the Integrity Check.
; The loader prints out an error message if kernel was not found.
nop

; mov ds, 0800h
push 0800h
pop ds

; Directive to create bin file:
#make_bin#

; Skip the data and function declaration section
jmp start
    text_10h_0Eh db 'Terman Emil Method 1 17.10.2018 0Eh', 0
    text_10h_0Ah db 'Terman Emil Method 2 17.10.2018 0Ah', 0
    text_10h_09h db 'Terman Emil Method 3 17.10.2018 09h', 0

    text_10h_1300h db 'Terman Emil Method 4 17.10.2018 1300h', 0
    text_10h_1300h_end db ?

    text_10h_1301h db 'Terman Emil Method 5 17.10.2018 1301h', 0
    text_10h_1301h_end db ?

    text_10h_1302h  db 'T', 07h,
                    db 'e', 05h,
                    db 'r', 07h,
                    db 'm', 07h,
                    db 'a', 07h,
                    db 'n', 07h,
                    db ' ', 07h,
                    db 'M', 07h,
                    db 'e', 07h,
                    db 't', 07h,
                    db 'h', 07h,
                    db 'o', 07h,
                    db 'd', 07h,
                    db ' ', 07h,
                    db '6', 04h,
                    db 0, 0
    text_10h_1302h_end:

    text_10h_1303h  db 'T', 07h,
                    db 'e', 05h,
                    db 'r', 07h,
                    db 'm', 07h,
                    db 'a', 07h,
                    db 'n', 07h,
                    db ' ', 07h,
                    db 'M', 07h,
                    db 'e', 07h,
                    db 't', 07h,
                    db 'h', 07h,
                    db 'o', 07h,
                    db 'd', 07h,
                    db ' ', 07h,
                    db '7', 04h,
                    db 0, 0
    text_10h_1303h_end:

    
    text_direct_video db 'Terman Emil Method 8 17.10.2018 Direct video', 0
    text_direct_video_end db ?

set_curs_pos MACRO pos_x, pos_y
    mov dh, pos_y
    mov dl, pos_x
    mov bh, 0
    mov ah, 02h 
    int 10h    
ENDM

print_with_10h_0Eh MACRO text, start_x, start_y
    ; Set cursor position.
    mov dh, start_y
    mov dl, start_x
    mov ah, 02h
    mov bh, 0
    int 10h

    ; Save start of string in si
    mov si, offset text

    while_loop_0Eh:
        mov ax, [si]
        
        ; If end of string.
        cmp al, 0
        je end_of_while_loop_0Eh

        ; Print char.
        ; al register already contains the required char.
        mov ah, 0Eh
        int 10h

        ; Increase the pointer.
        inc si
        jmp while_loop_0Eh

    end_of_while_loop_0Eh:
ENDM

print_with_10h_0Ah MACRO text, start_x, start_y
    mov si, 0

    ; Set page number to 0
    mov bh, 0

    ; Number of times to print a char = 1
    mov cx, 1

    while_loop_0Ah:
        mov al, text[si]
        cmp al, 0

        je end_of_while_loop_0Ah

        ; Set cursor position, since 0Ah doesn't change it.
        mov bx, start_x
        add bx, si
        set_curs_pos bl, start_y

        ; Print char if not end of string.
        mov al, text[si]
        mov ah, 0Ah
        int 10h

        inc si
        jmp while_loop_0Ah

    end_of_while_loop_0Ah:
ENDM

print_with_10h_09h MACRO text, start_x, start_y, attribute
    mov si, 0
    mov dx, start_x

    ; Set page number to 0
    mov bh, 0

    mov bl, attribute

    ; Number of times to print a char = 1
    mov cx, 1

    while_loop_09h:
        mov al, text[si]
        cmp al, 0

        je end_of_while_loop_09h

        ; Set cursor position, since 09h doesn't change it.
        set_curs_pos dl, start_y

        ; Print char if not end of string.
        mov al, text[si]
        mov ah, 09h
        int 10h

        inc si
        inc dx
        jmp while_loop_09h

    end_of_while_loop_09h:
ENDM

print_with_10h_1300h MACRO start_x, start_y, attribute
    ; Page number = 0.
    mov bh, 0

    ; Attributes.
    mov bl, attribute

    ; Message length.
    mov cx, text_10h_1300h_end - 1 - offset text_10h_1300h

    ; Pos x and y
    mov dl, start_x
    mov dh, start_y

    mov bp, offset text_10h_1300h

    mov al, 00h
    mov ah, 13h
    int 10h
ENDM

print_with_10h_1301h MACRO start_x, start_y, attribute
    ; Page number = 0.
    mov bh, 0

    ; Attributes.
    mov bl, attribute

    ; Message length.
    mov cx, text_10h_1301h_end - 1 - offset text_10h_1301h

    ; Pos x and y
    mov dl, start_x
    mov dh, start_y

    mov bp, offset text_10h_1301h

    mov al, 01h
    mov ah, 13h
    int 10h
ENDM

print_with_10h_1302h MACRO start_x, start_y
    ; Page number = 0.
    mov bh, 0

    ; Message length.
    mov cx, (offset text_10h_1302h_end - offset text_10h_1302h - 1) >> 1

    ; Pos x and y
    mov dl, start_x
    mov dh, start_y

    mov bp, offset text_10h_1302h

    mov al, 02h
    mov ah, 13h
    int 10h
ENDM

print_with_10h_1303h MACRO start_x, start_y
    ; Page number = 0.
    mov bh, 0

    ; Message length.
    mov cx, (offset text_10h_1303h_end - offset text_10h_1303h - 1) >> 1

    ; Pos x and y
    mov dl, start_x
    mov dh, start_y

    mov bp, offset text_10h_1303h

    mov al, 03h
    mov ah, 13h
    int 10h
ENDM

print_directly_in_video_buffer MACRO
    mov ax, 0B800h       ; segment address of textmode video buffer
    mov es, ax           ; store address in extra segment register

    ; Get the offset address of the string.
    mov si, offset text_direct_video

    ; Using a fixed target address for example (screen page 0)
    ; Position`on screen = (Line_number * 80 * 2) + (Row_number * 2)

    mov di, (18 * 80 * 2) + (10 * 2)

    ; Text length.
    mov cl, text_direct_video_end - 1 - offset text_direct_video

    ; Clear direction flag.
    cld

    video_print_loop:
        lodsb  ; get the string from the address in DS:SI + increase si
        stosb  ; write string directly to the screen using ES:DI + increase di
        inc di ; step over attribut byte
        dec cl ; decrease counter
        jnz video_print_loop
ENDM

pretty_print MACRO char1, char2
	mov ah, 0Eh

	mov al, char1
    int 10h

    mov al, char2
    int 10h
    
    mov al, ':'
    int 10h
    
    mov al, ' '
    int 10h
ENDM

; Print hex value from dx
print_hex_value PROC
	mov cx, 4
	hex_loop:
		; Save current dx.
		mov bx, dx

		; Mask last 4 bits.
		and bx, 0xf000
		shr bx, 3 * 4

		; Add ascii value depeing if it's a number or letter.
			cmp bx, 09h
			jg its_a_letter

			; its_a_number:
				add bx, 0x30
				jmp letter_or_nb_endif
			its_a_letter:
				add bx, 0x37

			letter_or_nb_endif:

		mov ax, bx
		mov ah, 0Eh
	    int 10h
        shl dx, 4

        loop hex_loop

	mov ax, 'h'
	mov ah, 0Eh
    int 10h
    ret
ENDP

print_next_reg MACRO reg_name_char1, reg_name_char2
	mov ah, 0Eh

	mov al, reg_name_char1
    int 10h

    mov al, reg_name_char2
    int 10h
    
    mov al, ':'
    int 10h
    
    mov al, ' '
    int 10h    

    pop dx
	call print_hex_value
ENDM

print_regs PROC
	; Save register values on stack, to restore after procedure ends.
	pusha

	; Save registers for printing.
	pusha

	set_curs_pos 0, 7
	print_next_reg 'D', 'I'

	set_curs_pos 0, 6
	print_next_reg 'S', 'I'

	set_curs_pos 0, 5
	print_next_reg 'B', 'P'

	set_curs_pos 0, 4
	print_next_reg 'S', 'P'

	set_curs_pos 0, 3
	print_next_reg 'B', 'X'

	set_curs_pos 0, 2
	print_next_reg 'D', 'X'

	set_curs_pos 0, 1
	print_next_reg 'C', 'X'	

	set_curs_pos 0, 0
	print_next_reg 'A', 'X'

	popa
	ret
ENDP

start:
    ; 10h 0Eh
        print_with_10h_0Eh text_10h_0Eh, 10, 4

    ; 10h 0Ah
        print_with_10h_0Ah text_10h_0Ah, 10, 6

    ; 10h 09h
        print_with_10h_09h text_10h_09h, 10, 8, 0000_0010b

    ; 10h 1300h
        print_with_10h_1300h 10, 10, 0000_0100b

    ; 10h 1301h
        print_with_10h_1301h 10, 12, 0000_0101b

    ; 10h 1302h
        print_with_10h_1302h 10, 14

    ; 10h 1303h
        print_with_10h_1303h 10, 16

    ; Directly print into video buffer.
        print_directly_in_video_buffer

    ; ASCII
    	set_curs_pos 10, 20
		xor si, si
	    ascii_print_loop:
	    	mov ax, si
	    	mov ah, 0Eh
	        int 10h

	    	inc si

	    	cmp si, 256
	    	jne ascii_print_loop
	
	; Print regs
		mov ax, 0x0420
		mov bx, 0xA42A

		call print_regs

    read_key_loop:
        mov ah, 00h
        int 16h
        jmp read_key_loop