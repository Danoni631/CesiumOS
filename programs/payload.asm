[bits 16]
[ORG 0x0000]

%define WSCREEN 320
%define HSCREEN 200

programmain:
    mov ax, 0x13
    int 0x10
    
    fninit

animation:
    mov ax, 0xa000
    mov es, ax
    xor di, di
    xor cx, cx      ; y
.y:
    xor dx, dx      ; x
.x:
    mov ax, dx
    add ax, [word_timer]
    mov si, cx
    add si, [word_timer]
    imul ax, si
    and al, 0x3F
    stosb
    inc dx
    cmp dx, WSCREEN
    jne .x
    inc cx
    cmp cx, HSCREEN
    jne .y
    
    mov si, msg
    call print_string_center
    inc word [word_timer]
    jmp end_frame

msg     db "CUSTOM PROGRAM", 0
word_timer      dw 0
timer: db 0

%include "CesiumOS/graphical/graphics.asm"
%include "CesiumOS/graphical/print.asm"
%include "CesiumOS/include/cesium.asm"