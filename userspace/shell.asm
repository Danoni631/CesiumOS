%define BUFFSIZE 0x40

shell_loop:
    mov si, prompt
    call print_text_mode
    
    call read_string
    mov si, cmd_buffer
    
    cmp byte [si], 0
    je shell_loop
    
    mov di, cmd_gui
    call strcmp
    jc load_gui

    mov di, cmd_audio
    call strcmp
    jc play_sound

    mov di, cmd_stopaudio
    call strcmp
    jc stop_sound

    mov di, cmd_help
    call strcmp
    jc help_msg

    mov si, msg_unknown
    call print_text_mode
    jmp shell_loop

    mov si, cmd_cls
    call strcmp
    call do_cls

    mov si, cmd_dir
    call strcmp
    call do_dir

    mov si, cmd_fetch
    call strcmp
    jc fetch

    mov si, cmd_reset
    call strcmp
    jc restart

    mov si, cmd_poweroff
    call strcmp
    jc poweroff

    mov si, cmd_run
    call strcmp
    jc findprogram


do_cls:
    mov ax, 0x0003
    int 0x10
    jmp shell_loop

do_dir:
    call printroot
    int 0x10
    jmp shell_loop

msg_welcome       db "Welcome to CesiumOS Shell! (NO GUI)", 0x0D, 0x0A, 0,
                  db "Type 'help' to start with shell", 0x0D, 0x0A, 0,
prompt            db "root/CesiumOS:/> ", 0
cmd_gui           db "gui", 0,
cmd_dir           db "dir", 0
cmd_help          db "help", 0
cmd_stopaudio     db "audiostop", 0
cmd_audio         db "audio", 0
cmd_cls           db "cls", 0
cmd_fetch         db "fetch" , 0
cmd_reset         db "reset", 0
cmd_poweroff      db "poweroff", 0
cmd_run           db "run", 0

msg_unknown     db "Invalid Command! Try again or type 'help'", 0x0D, 0x0A, 0,

help_msg          db "poweroff, reset, run, dir, audio, audiostop, gui, fetch", 0x0D, 0x0A, 0,
fetch: db "  ###   ###          System: Your name", 0x0D, 0x0A, 0,
       db " #     #             Kernel: CesiumOS v1.0", 0x0D, 0x0A, 0
       db " #      ##           Resolution: 320x200", 0x0D, 0x0A, 0
       db " #        #          Your name UI version: v1.0", 0x0D, 0x0A, 0
       db "  ###  ###           Memory (kb): ", 0x0D, 0x0A, 0

argbuff:
    times 8 db 0x20
    times BUFFSIZE / 2 db 0x00