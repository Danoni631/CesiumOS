%define WSCREEN 320
%define HSCREEN 200

end_frame:
    mov dx, 0x3DA
.wait:
    in al, dx
    test al, 8
    jz .wait
    
    jmp animation

delay:
    mov cx, 0x07FF
wait_loop:
    loop wait_loop

    mov ah, 01h
    int 16h
    jz animation

    ret

nextline:
    mov word [cursorX], 0
    inc word [cursorY]

    ret

cursorX: dw 0
cursorY: dw 0