read_string:
    mov di, cmd_buffer
    xor cx, cx
.loop:
    mov ah, 0x00
    int 0x16
    cmp al, 0x0D
    je .done
    cmp al, 0x08
    je .backspace
    
    cmp cx, 64
    je .loop
    
    mov [di], al
    inc di
    inc cx
    mov ah, 0x0E
    int 0x10
    jmp .loop

.backspace:
    cmp cx, 0
    jbe .loop
    
    dec di
    dec cx

    mov ah, 0x0E
    mov al, 0x08
    int 0x10
    mov al, ' '
    int 0x10
    mov al, 0x08
    int 0x10
    jmp .loop
.done:
    mov byte [di], 0
    mov ah, 0x0E
    mov al, 0x0A
    int 0x10
    mov al, 0x0D
    int 0x10
    ret