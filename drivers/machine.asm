restart:
    mov al, 0xFE
    out 0x64, al

    cli
    hlt

    jmp $

poweroff:
    mov ax, 0x5307
    mov bx, 0x01
    mov cx, 0x03

    int 0x15

    cli
    hlt

    jmp $