; Vista previa de interfaz: no implementa movimiento ni reglas de juego.
org 100h
jmp inicio
include 'interfaz.inc'
DEFINE_INTERFACE

;
player_x db 1
player_y db 1
lives db 3
score dw 0
high_score dw 0
moves dw 0
; Muestra visual: # pared, espacio pasillo, . objeto, E salida.
mapa db '####################'
     db '#   .  #     .     #'
     db '# ###  # #### ###  #'
     db '#   #    #    #    #'
     db '### #### # ## # ####'
     db '#   .    #  # #    #'
     db '# ###### ## # #### #'
     db '#      #    #      #'
     db '# #### ########### #'
     db '# #    #   .       #'
     db '# # #### ####### ###'
     db '# #      #     #   #'
     db '# ###### # ### ### #'
     db '#   .      #      E#'
     db '####################'
inicio:
    push cs
    pop ds
    call ui_init
preview_menu:
    call ui_menu
preview_menu_key:
    mov ah, 0
    int 16h
    cmp al, 27
    je preview_exit
    cmp al, '1'
    jne preview_menu_key
preview_board:
    call ui_board
preview_key:
    mov ah, 0
    int 16h
    cmp al, 27
    je preview_exit
    or al, 20h
    cmp al, 'm'
    je preview_menu
    cmp al, 'v'
    je preview_win
    cmp al, 'g'
    je preview_lose
    cmp al, 'p'
    je preview_pause
    jmp preview_key
preview_win:
    call ui_win
    jmp preview_return
preview_lose:
    call ui_lose
    jmp preview_return
preview_pause:
    call ui_pause
preview_return:
    mov ah, 0
    int 16h
    jmp preview_board
preview_exit:
    call ui_shutdown
    mov ax, 4C00h
    int 21h
