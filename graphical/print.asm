print_string_center:
    ; Reset cursor
    mov ah, 02h
    xor bh, bh
    mov dx, 0x0C0F
    int 10h
.loop:
    lodsb
    test al, al
    jz .done
    mov ah, 0x0E
    mov bl, [timer]
    and bl, 0x0F
    add bl, 32
    int 10h
    jmp .loop
.done:
    ret

print_text_mode:
    mov ah, 0x0E
.loop:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .loop
.done:
    ret
    
print_string:
    mov ah, 0x0e
.l: 
    lodsb
    or al, al
    jz .d
    int 0x10
    jmp .l
.d: ret

print_string_gui:
    mov ah, 0x0e
    mov bl, 15       
.l: 
    lodsb
    or al, al
    jz .d
    int 0x10
    jmp .l
.d: ret