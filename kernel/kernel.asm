[bits 16]
[ORG 0x0000]

%define WSCREEN 320
%define HSCREEN 200

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

kernel_main:
    mov ax, cs
    mov ds, ax
    mov es, ax

    mov si, msg_welcome
    call print_text_mode


cmd_buffer        times 65 db 0
timer             db 0
word_timer      dw 0

%include "CesiumOS/graphical/graphics.asm"
%include "CesiumOS/filesystem/disk.asm"
%include "CesiumOS/drivers/audio.asm"
%include "CesiumOS/drivers/mouse.asm"
%include "CesiumOS/drivers/kb.asm"
%include "CesiumOS/hardware/cpu.asm"
%include "CesiumOS/hardware/memory.asm"
%include "CesiumOS/filesystem/fat.asm"
%include "CesiumOS/graphical/print.asm"
%include "CesiumOS/drivers/machine.asm"
%include "CesiumOS/userspace/shell.asm"
%include "CesiumOS/userspace/ui.asm"

msg     db "dqjdwjdejwdijewj", 0

rootdirbuff: