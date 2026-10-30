; INTEGRANTE 1. Solo presentacion; no cambia variables del juego.
; DS=segmento del COM. Rutinas publicas preservan registros, no flags.
; Usa modo texto 80x25 y memoria B800h, sin macros externas de EMU8086.
UI_LABEL macro fila, columna, texto, color
    mov dh, fila
    mov dl, columna
    lea si, texto
    mov bl, color
    call ui_text
endm

; EMU8086 importa macros desde INCLUDE. Esta macro emite datos y rutinas.
DEFINE_INTERFACE macro
MAP_W equ ANCHO
MAP_H equ ALTO
MAP_TOP equ 6
MAP_LEFT equ 5

ui_title db 'M A Z E  /  8 0 8 6',0
ui_tag db 'ENCUENTRA TU CAMINO',0
ui_project db 'EIF205  /  ARQUITECTURA DE COMPUTADORAS',0
ui_start db '[1]  ENTRAR AL LABERINTO',0
ui_exit db '[ESC]  SALIR',0
ui_rules db 'WASD/Flechas: mover  P: pausa  Q/ESC: menu',0
ui_goal db 'Recoge todas las monedas y llega a la salida S.',0
ui_controls db 'C: moneda (+10)   X: trampa (-1 vida)   S: salida (+50)',0
ui_side db 'TU RECORRIDO',0
ui_score_label db 'PUNTOS',0
ui_record_label db 'RECORD',0
ui_vidas_label db 'VIDAS',0
ui_moves_label db 'MOVIMIENTOS',0
ui_legend1 db '@  TU JUGADOR',0
ui_legend2 db 'S  SALIDA',0
ui_legend3 db 'X  TRAMPA',0
ui_coins_label db 'MONEDAS RESTANTES',0
ui_win_title db 'L A B E R I N T O  S U P E R A D O',0
ui_win_msg db 'Encontraste la salida. Buen recorrido.',0
ui_lose_title db 'F I N  D E  L A  P A R T I D A',0
ui_lose_msg db 'Se agotaron tus vidas. Intentalo otra vez.',0
ui_pause_title db 'P A U S A',0
ui_pause_msg db 'Tu recorrido te espera.',0
ui_final_keys db 'R: reiniciar   M/Q: menu   ESC: salir',0
ui_status_keys db 'Partida terminada: R reinicia conservando tu record.',0
ui_pause_keys db 'P/ENTER: continuar   Q/ESC: menu',0
ui_number_buffer db '00000',0

ui_init proc near
    push ax
    push cx
    mov ax, 0003h
    int 10h
    mov ah, 01h
    mov cx, 2000h
    int 10h
    pop cx
    pop ax
    ret
ui_init endp
ui_shutdown proc near
    push ax
    mov ax, 0003h
    int 10h
    pop ax
    ret
ui_shutdown endp

; DH=fila, DL=columna -> DI=offset en B800h.
ui_offset proc near
    push ax
    push bx
    push dx
    xor ax, ax
    mov al, dh
    mov bx, 160
    mul bx
    mov di, ax
    pop dx
    xor ax, ax
    mov al, dl
    shl ax, 1
    add di, ax
    pop bx
    pop ax
    ret
ui_offset endp

; DH/DL=posicion, AL=caracter, BL=color, CX=repeticiones.
ui_fill proc near
    push ax
    push cx
    push di
    push es
    push ax
    mov ax, 0B800h
    mov es, ax
    pop ax
    call ui_offset
    mov ah, bl
    cld
    rep stosw
    pop es
    pop di
    pop cx
    pop ax
    ret
ui_fill endp

; DS:SI=cadena terminada en cero, DH/DL=posicion, BL=color.
ui_text proc near
    push ax
    push si
    push di
    push es
    mov ax, 0B800h
    mov es, ax
    call ui_offset
    cld
ui_text_next:
    lodsb
    or al, al
    jz ui_text_done
    mov ah, bl
    stosw
    jmp ui_text_next
ui_text_done:
    pop es
    pop di
    pop si
    pop ax
    ret
ui_text endp

; AX=numero sin signo, DH/DL=posicion, BL=color; cinco digitos.
ui_number proc near
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push dx
    push bx
    lea di, ui_number_buffer+4
    mov bx, 10
    mov cx, 5
ui_number_digit:
    xor dx, dx
    div bx
    add dl, '0'
    mov [di], dl
    dec di
    loop ui_number_digit
    pop bx
    pop dx
    lea si, ui_number_buffer
    call ui_text
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
ui_number endp

ui_clear proc near
    push ax
    push bx
    push cx
    push dx
    xor dx, dx
    mov al, ' '
    mov bl, 07h
    mov cx, 2000
    call ui_fill
    mov bl, 30h
    mov cx, 80
    call ui_fill
    mov dh, 24
    mov bl, 17h
    call ui_fill
    pop dx
    pop cx
    pop bx
    pop ax
    ret
ui_clear endp

ui_menu proc near
    push ax
    push bx
    push cx
    push dx
    push si
    call ui_clear
    UI_LABEL 0, 3, ui_project, 30h
    UI_LABEL 6, 29, ui_title, 0Bh
    UI_LABEL 8, 30, ui_tag, 0Fh
    UI_LABEL 12, 26, ui_start, 0Ah
    UI_LABEL 14, 26, ui_exit, 07h
    UI_LABEL 18, 15, ui_goal, 07h
    UI_LABEL 20, 17, ui_rules, 08h
    UI_LABEL 24, 3, ui_controls, 17h
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
ui_menu endp

; Cada celda ocupa dos columnas. No altera mapa ni coordenadas.
ui_board proc near
    push ax
    push bx
    push cx
    push dx
    push si
    call ui_clear
    UI_LABEL 0, 3, ui_title, 30h
    UI_LABEL 3, 5, ui_goal, 07h
    lea si, mapa
    mov dh, MAP_TOP
ui_map_row:
    mov dl, MAP_LEFT
ui_map_cell:
    lodsb
    mov bl, 07h
    cmp al, '#'
    je ui_map_wall
    cmp al, 'S'
    je ui_map_exit
    cmp al, 'C'
    je ui_map_coin
    cmp al, 'X'
    je ui_map_trap
    mov al, ' '
    jmp ui_map_paint
ui_map_wall:
    mov al, 219
    mov bl, 09h
    jmp ui_map_paint
ui_map_exit:
    mov bl, 0Ah
    jmp ui_map_paint
ui_map_coin:
    mov bl, 0Eh
    jmp ui_map_paint
ui_map_trap:
    mov bl, 0Ch
ui_map_paint:
    mov cx, 2
    call ui_fill
    add dl, 2
    cmp dl, MAP_LEFT+MAP_W*2
    jb ui_map_cell
    inc dh
    cmp dh, MAP_TOP+MAP_H
    jb ui_map_row
    mov dh, [jugador_y]
    add dh, MAP_TOP
    mov dl, [jugador_x]
    shl dl, 1
    add dl, MAP_LEFT
    mov al, '@'
    mov bl, 0Fh
    mov cx, 1
    call ui_fill
    call ui_hud
    UI_LABEL 22, 5, ui_rules, 07h
    UI_LABEL 24, 3, ui_controls, 17h
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
ui_board endp

ui_hud proc near
    push ax
    push bx
    push dx
    push si
    UI_LABEL 6, 51, ui_side, 0Bh
    UI_LABEL 8, 51, ui_score_label, 07h
    mov ax, [puntos]
    mov dx, 0933h
    mov bl, 0Fh
    call ui_number
    UI_LABEL 11, 51, ui_record_label, 07h
    mov ax, [record_max]
    mov dx, 0C33h
    mov bl, 0Eh
    call ui_number
    UI_LABEL 14, 51, ui_vidas_label, 07h
    xor ax, ax
    mov al, [vidas]
    mov dx, 0F33h
    mov bl, 0Ah
    call ui_number
    UI_LABEL 17, 51, ui_moves_label, 07h
    mov ax, [movimientos]
    mov dx, 1233h
    mov bl, 0Fh
    call ui_number
    UI_LABEL 19, 51, ui_coins_label, 07h
    xor ax, ax
    mov al, [monedas]
    mov dx, 1433h
    mov bl, 0Eh
    call ui_number
    UI_LABEL 21, 51, ui_legend1, 0Fh
    UI_LABEL 22, 51, ui_legend2, 0Ah
    UI_LABEL 23, 51, ui_legend3, 0Ch
    pop si
    pop dx
    pop bx
    pop ax
    ret
ui_hud endp

; AL=0 pausa, AL=1 victoria, otro valor derrota.
; Solo dibuja; el integrante 3 decide el estado y procesa el teclado.
ui_end_screen proc near
    push ax
    push bx
    push cx
    push dx
    push si
    call ui_clear
    UI_LABEL 0, 3, ui_title, 30h
    cmp al, 0
    je ui_end_pause
    cmp al, 1
    je ui_end_win
    UI_LABEL 7, 21, ui_lose_title, 0Ch
    UI_LABEL 10, 19, ui_lose_msg, 07h
    jmp ui_end_common
ui_end_win:
    UI_LABEL 7, 21, ui_win_title, 0Ah
    UI_LABEL 10, 20, ui_win_msg, 07h
    jmp ui_end_common
ui_end_pause:
    UI_LABEL 7, 34, ui_pause_title, 0Bh
    UI_LABEL 10, 28, ui_pause_msg, 07h
ui_end_common:
    UI_LABEL 13, 23, ui_score_label, 07h
    mov ax, [puntos]
    mov dx, 0E17h
    mov bl, 0Fh
    call ui_number
    UI_LABEL 13, 47, ui_record_label, 07h
    mov ax, [record_max]
    mov dx, 0E2Fh
    mov bl, 0Eh
    call ui_number
    cmp byte ptr [estado], 4
    je ui_end_pause_keys
    UI_LABEL 19, 19, ui_final_keys, 07h
    UI_LABEL 24, 3, ui_status_keys, 17h
    jmp ui_end_done
ui_end_pause_keys:
    UI_LABEL 19, 23, ui_pause_keys, 0Bh
    UI_LABEL 24, 3, ui_pause_keys, 17h
ui_end_done:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
ui_end_screen endp
ui_pause proc near
    push ax
    mov al, 0
    call ui_end_screen
    pop ax
    ret
ui_pause endp
ui_win proc near
    push ax
    mov al, 1
    call ui_end_screen
    pop ax
    ret
ui_win endp
ui_lose proc near
    push ax
    mov al, 2
    call ui_end_screen
    pop ax
    ret
ui_lose endp
endm
