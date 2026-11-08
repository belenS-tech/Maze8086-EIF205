; MAZE8086 - Integracion de interfaz, movimiento, reglas, cronometro y sonido.
; Compilar como COM en EMU8086 y ejecutar MAZE.COM en DOSBox-X.
org 100h
jmp inicio              ; 3 bytes: los datos empiezan en 0103h

ANCHO equ 20
ALTO equ 15
TOTAL equ ANCHO*ALTO
MONEDAS_TOTAL equ 5
TIEMPO_BONO equ 120     ; segundos de referencia para el bono de tiempo
TICKS_MAX_SALTO equ 91  ; 5 s; un salto mayor se ignora (medianoche o emulador detenido)

; Alineacion: un byte de relleno deja todas las variables word en
; direcciones pares (0104h en adelante). El 8086 lee una word par en un
; solo acceso al bus; una word impar necesita dos.
relleno_alineacion db 0

; Variables de 16 bits, sin signo, en direcciones pares.
puntos dw 0
record_max dw 0
movimientos dw 0
segundos dw 0           ; tiempo de la partida mostrado en pantalla
ticks_partida dw 0      ; ticks del BIOS acumulados en estado de partida
tick_anterior dw 0      ; ultima lectura de INT 1Ah (palabra baja)

; Variables de 8 bits. Coordenadas desde cero.
jugador_x db 1
jugador_y db 1
vidas db 3
monedas db MONEDAS_TOTAL
; 0 menu, 1 jugando, 2 victoria, 3 derrota, 4 pausa.
estado db 0

; Mapa original inmutable para restaurar monedas y trampas al reiniciar.
; # pared, C moneda, X trampa consumible, S salida.
mapa_original db '####################'
              db '#   C  #     C     #'
              db '# ###  # #### ###  #'
              db '#  X#    #    #    #'
              db '### #### # ## # ####'
              db '#   C    #  # #    #'
              db '# ###### ## # #### #'
              db '#      #X   #      #'
              db '# #### ########### #'
              db '# #    #   C       #'
              db '# # #### ####### ###'
              db '# #      #     # X #'
              db '# ###### # ### ### #'
              db '#   C      #      S#'
              db '####################'
mapa db TOTAL dup(' ')

include 'interfaz.inc'
include 'movimiento.inc'
include 'juego.inc'
include 'sonido.inc'
DEFINE_INTERFACE
DEFINE_MOVIMIENTO
DEFINE_JUEGO
DEFINE_SONIDO

inicio:
    push cs
    pop ds
    cld
    call ui_init

; El menu, la pausa y los finales esperan teclado con INT 16h/00h.
; La partida consulta el teclado sin bloquear para actualizar el reloj.
mostrar_menu:
    mov estado,0
    call ui_menu
esperar_menu:
    mov ah,0
    int 16h
    cmp al,27
    jne menu_comprobar_inicio
    jmp salir
menu_comprobar_inicio:
    cmp al,'1'
    jne esperar_menu
nueva_partida:
    call reiniciar_juego

dibujar_partida:
    call ui_board
esperar_jugada:
    ; Mientras no hay tecla, el reloj sigue avanzando en pantalla.
    call actualizar_tiempo
    mov ah,1
    int 16h                 ; ZF=1: no hay tecla en el buffer
    jz esperar_jugada
    mov ah,0
    int 16h                 ; retirar la tecla del buffer
    call procesar_movimiento
    cmp estado,0
    jne comprobar_pausa
    jmp mostrar_menu
comprobar_pausa:
    cmp estado,4
    jne comprobar_victoria
    jmp mostrar_pausa
comprobar_victoria:
    cmp estado,2
    jne comprobar_derrota
    call ui_win
    jmp esperar_final
comprobar_derrota:
    cmp estado,3
    jne dibujar_partida
    call ui_lose
    jmp esperar_final

mostrar_pausa:
    call ui_pause
esperar_pausa:
    mov ah,0
    int 16h
    cmp al,27
    jne pausa_comprobar_enter
    jmp mostrar_menu
pausa_comprobar_enter:
    cmp al,13
    je continuar_partida
    or al,20h
    cmp al,'q'
    jne pausa_comprobar_p
    jmp mostrar_menu
pausa_comprobar_p:
    cmp al,'p'
    jne esperar_pausa
continuar_partida:
    mov estado,1
    call iniciar_reloj      ; el tiempo en pausa no se cuenta
    jmp dibujar_partida

esperar_final:
    mov ah,0
    int 16h
    cmp al,27
    je salir
    or al,20h
    cmp al,'r'
    jne final_comprobar_menu
    jmp nueva_partida
final_comprobar_menu:
    cmp al,'m'
    je final_menu
    cmp al,'q'
    jne esperar_final
final_menu:
    jmp mostrar_menu

salir:
    call ui_shutdown
    mov ax,4C00h
    int 21h