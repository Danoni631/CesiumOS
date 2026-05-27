SectorsPerTrack: dw 63
NumberofHeads:   dw 16
DriveNumber:     db 0

lbatochs:
    push ax
    push dx

    xor dx, dx
    div word [SectorsPerTrack]

    inc dx
    mov cx, dx

    xor dx, dx
    div word [SectorsPerTrack]

    mov dh, dl

    mov ch, al
    shl ah, 0x06
    or cl, ah

    pop ax

    mov dl, al

    pop ax

    ret

readdisk:
    pusha

    push cx

    call lbatochs

    pop ax

    mov ah, 0x02
    int 0x13

    popa

    ret