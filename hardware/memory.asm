strcmp:
.loop:
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    jne .not_equal
    cmp al, 0
    je .equal
    inc si
    inc di
    jmp .loop
.not_equal:
    clc
    ret
.equal:
    stc
    ret

detectxms:
    pusha

    clc

    mov eax, 0xE801
    int 0x15

    jc errxms

    mov ax, bx

    popa

    ret

errxms:
    mov si, XMSErrorMessage
    mov al, 40
    call print_text_mode
    popa

    ret

XMSErrorMessage     db "XMS Failed!", 0x00