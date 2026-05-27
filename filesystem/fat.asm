%define EXESEGMENT 0x9000
%define EXEOFFSET 0x0100

loadrootdir:
    pusha
    
    mov ax, 19
    mov cl, al
    mov bx, rootdirbuff
    mov dl, [DriveNumber]
    call readdisk

    popa

    ret

printroot:
    call nextline

    xor bx, bx
    xor si, si

    nextentry:
        mov dl, 0x00
        mov cx, 11
        mov al, [rootdirbuff]

        cmp al, 0x0F
        jz entryskip

    printfile:
        mov al, [rootdirbuff + si]

        cmp dl, 0x01
        jz printfilechar

        mov dl, 0x01

        cmp al, 0x00
        jz printroot.end

    printfilechar:
        push bx

        mov bl, 0x32
        call print_text_mode

        pop bx

        inc si

        cmp cl, 0x04
        jnz continueprint

        mov al, ' '
        call print_text_mode

    continueprint:
        loop printfile

        call nextline

    checkdirend:
        inc bx

        cmp bx, 128
        jz printroot.end

        add si, 21
        jmp nextentry

    entryskip:
        add si, 11
        jmp checkdirend

printroot.end:
    ret

findprogram:
    xor bx, bx
    mov di, rootdirbuff

    .searchprog:
        mov si, argbuff
        mov cx, 8
        push di
        repe cmpsb
        pop di

        je .programfound

        add di, 0x20
        inc bx

        cmp bx, 0xE0
        jl .searchprog

        jmp .errexe

    .programfound:
        mov ax, [di + 26]
        mov [progclus], ax

        mov ax, 0x01
        mov bx, rootdirbuff
        mov cl, 0x09
        mov dl, [DriveNumber]
        call readdisk

        call runprogram

        ret

.errexe:
    call nextline
    
    mov si, EXEFAIL
    mov al, 0x0C
    call print_text_mode

    ret

runprogram:
    mov bx, EXESEGMENT
    mov es, bx
    mov bx, EXEOFFSET

    .kernelloop:
        mov ax, [progclus]

        mov dl, [DriveNumber]
        add ax, 0x1F
        mov cl, 0x01
        call readdisk

        add bx, 512

        mov ax, [progclus]
        mov cx, 0x03
        mul cx

        mov cx, 0x02
        div cx

        mov si, rootdirbuff
        add si, ax
        mov ax, [ds:si]

        or dx, dx
        jz .even

    .odd:
        shr ax, 0x04
        jmp .nextcluster

    .even:
        and ax, 0x0FFF

    .nextcluster:
        cmp ax, 0x0FF8
        jae .end

        mov [progclus], ax
        jmp .kernelloop

    .end:
        mov dl, [DriveNumber]
        mov ax, EXESEGMENT
        mov ds, ax
        mov es, ax

        jmp EXESEGMENT:EXEOFFSET

        cli
        hlt

EXEFAIL: db "Invalid program!", 0x00

progclus: dw 0x00