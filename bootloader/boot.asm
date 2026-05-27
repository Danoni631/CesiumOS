[bits 16]
[ORG 0x7C00]

jmp short boot_start
nop

oem_name        db "SATURNOS"
bytes_per_sec   dw 512
sec_per_cluster db 8
reserved_secs   dw 32
num_fats        db 2
root_dir_entries dw 0
total_secs_16   dw 0
media_type      db 0xF8
fat_size_16     dw 0
sec_per_track   dw 18
num_heads       dw 2
hidden_sectors  dd 0
total_secs_32   dd 0x000F4240

fat_size_32     dd 0x000003E8
ext_flags       dw 0
fs_version      dw 0
root_cluster    dd 2
fs_info_sec     dw 1
bk_boot_sec     dw 6
reserved        times 12 db 0
drive_num       db 0x80
reserved1       db 0
boot_sig        db 0x29
volume_id       dd 0xDEADC0DE
volume_label    db "SATURN OS  "
file_system     db "FAT32   "

boot_start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    mov [drive_num], dl

    mov bx, 0x1000
    mov es, bx
    xor bx, bx

    mov ah, 0x02
    mov al, 10
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [drive_num]
    int 0x13
    jc disk_error

    jmp 0x1000:0x0000

disk_error:
    mov si, msg_error
    call print_string
    cli
    hlt

print_string:
    mov ah, 0x0E
.loop:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .loop
.done:
    ret

msg_error db "Don't have a kernel in system", 0

times 510-($-$$) db 0
dw 0xAA55