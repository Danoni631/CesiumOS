%define WCURSOR 8
%define HCURSOR 11

startmouse:
    mov ax, 0xC205
    mov bh, 0x03
    int 0x15
    mov ax, 0xC203
    mov bh, 0x03
    int 0x15
    ret

enablemouse:
    mov ax, 0xC207
    mov bx, mousecallback
    int 0x15
    mov ax, 0xC200
    mov bh, 0x01
    int 0x15
    ret

mousecallback:
    push bp
    mov bp, sp
    pusha
    push ds
    push es

    xor ax, ax
    mov ds, ax

    mov al, 0
    call drawcursor
    
    mov bl, [bp + 12]
    
    mov ax, [bp + 10]
    test bl, 0x10
    jz .x_pos
    or ax, 0xFF00
.x_pos: 
    add [MouseX], ax

    mov ax, [bp + 8]
    test bl, 0x20
    jz .y_pos
    or ax, 0xFF00
.y_pos: 
    sub [MouseY], ax 

    cmp word [MouseX], 0
    jge .check_max_x
    mov word [MouseX], 0
.check_max_x:
    cmp word [MouseX], 315
    jle .check_min_y
    mov word [MouseX], 315

.check_min_y:
    cmp word [MouseY], 0
    jge .check_max_y
    mov word [MouseY], 0
.check_max_y:
    cmp word [MouseY], 195
    jle .done_clipping
    mov word [MouseY], 195

.done_clipping:
    mov al, 15
    call drawcursor

    test byte [bp + 12], 1
    jnz .check_click_area

    pop es
    pop ds
    popa
    pop bp
    retf

.check_click_area:
    pop es
    pop ds
    popa
    pop bp
    retf

.move:
    mov al, 15
    call drawcursor
    pop es
    pop ds
    popa
    pop bp
    retf

.checkclick:
    cmp word [MouseY], 182
    jl .move
    cmp word [MouseX], 60
    jg .move
    call draw_start_menu
    jmp .move

drawcursor:
    pusha
    mov dx, [MouseY]
    mov si, mousebmp
    mov di, 11
    mov bl, al
.loopY:
    lodsb
    mov bh, al
    mov cx, [MouseX]
    mov bp, 8
.loopX:
    test bh, 0x80
    jz .skip
    mov ah, 0x0C
    mov al, bl
    push bx
    xor bx, bx
    int 0x10
    pop bx
.skip:
    inc cx
    shl bh, 1
    dec bp
    jnz .loopX
    inc dx
    dec di
    jnz .loopY
    popa
    ret

MouseX  dw 0
MouseY  dw 0

mousebmp:
    db 0b10000000
    db 0b11000000
    db 0b11100000
    db 0b11110000
    db 0b11111000
    db 0b11111100
    db 0b11111110
    db 0b11111111
    db 0b11011100
    db 0b10001100
    db 0b10001100