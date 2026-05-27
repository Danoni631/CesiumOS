load_gui:
    mov ax, 0x0013
    int 0x10
    call startmouse
    call enablemouse
    call draw_full_desktop

draw_taskbar:
    mov ax, 0xA000
    mov es, ax
    mov di, 320*182
    mov al, 20        
    mov cx, 320*18
    rep stosb
    
    mov dx, 0x1701  
    mov ah, 2
    xor bh, bh
    int 0x10
    
    mov si, btn_start
    call print_string_gui
    ret

draw_start_menu:
    mov bx, 100
.l: 
    mov ax, 320
    mul bx
    mov di, ax
    mov al, 8
    mov cx, 80
    call draw_line_gui
    inc bx
    cmp bx, 182
    jne .l
    mov dx, 0x0D01
    mov ah, 2
    int 0x10
    mov si, username
    call print_string
    ret

draw_full_desktop:
    mov ax, 0xA000
    mov es, ax
    xor di, di
.l1: 
    mov ax, di
    shr ax, 8
    add al, 45
    stosb
    cmp di, 320*182
    jb .l1
    call draw_taskbar
    ret

draw_line_gui:
    push es
    push ax
    mov ax, 0xA000
    mov es, ax
    pop ax
    rep stosb
    pop es
    ret

username    db "Admin", 0
btn_start   db "[START]", 0