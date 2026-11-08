; Efectos de sonido con el parlante del PC (PC speaker).
; El temporizador 8253/8254 genera una onda cuadrada en su canal 2:
;   puerto 43h = control, puerto 42h = divisor del canal 2,
;   puerto 61h bits 0 y 1 = conectan el canal 2 al parlante.
; La frecuencia es 1193180 / divisor. La duracion se mide en ticks del
; BIOS (INT 1Ah, unos 55 ms cada uno), sin bucles de retraso vacios.

; SONAR divisor, ticks: toca una nota. Modifica BX y CX; las rutinas que
; la usan los guardan antes.
SONAR macro divisor, duracion
    mov bx, divisor
    mov cx, duracion
    call sonido_tono
endm

DEFINE_SONIDO macro
; Divisores de las notas usadas (1193180 / frecuencia en Hz).
NOTA_DO5  equ 2280      ; 523 Hz
NOTA_MI5  equ 1810      ; 659 Hz
NOTA_SOL5 equ 1521      ; 784 Hz
NOTA_DO6  equ 1140      ; 1047 Hz
NOTA_MI6  equ 905       ; 1319 Hz
NOTA_SOL4 equ 3043      ; 392 Hz
NOTA_MI4  equ 3619      ; 330 Hz
NOTA_DO4  equ 4560      ; 262 Hz
NOTA_GRAVE equ 9121     ; 131 Hz, tono de error

; BX = divisor, CX = duracion en ticks. Preserva todos los registros.
sonido_tono proc near
    push ax
    push bx
    push cx
    push dx
    mov al, 0B6h            ; canal 2, escribir byte bajo y alto, modo 3
    out 43h, al
    mov al, bl
    out 42h, al             ; byte bajo del divisor
    mov al, bh
    out 42h, al             ; byte alto del divisor
    in al, 61h
    or al, 03h              ; encender el parlante
    out 61h, al
    call esperar_ticks
    in al, 61h
    and al, 0FCh            ; apagar el parlante
    out 61h, al
    pop dx
    pop cx
    pop bx
    pop ax
    ret
sonido_tono endp

; CX = ticks a esperar. Compara lecturas de INT 1Ah; la resta sin signo
; tambien termina si el contador vuelve a cero a medianoche.
esperar_ticks proc near
    push ax
    push bx
    push cx
    push dx
    push di
    mov bx, cx
    mov ah, 0
    int 1Ah
    mov di, dx              ; DI = tick inicial
et_ciclo:
    mov ah, 0
    int 1Ah
    mov ax, dx
    sub ax, di
    cmp ax, bx
    jb et_ciclo
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret
esperar_ticks endp

; Moneda: dos notas agudas y cortas.
sonido_moneda proc near
    push bx
    push cx
    SONAR NOTA_DO6, 1
    SONAR NOTA_MI6, 2
    pop cx
    pop bx
    ret
sonido_moneda endp

; Trampa: una nota grave.
sonido_trampa proc near
    push bx
    push cx
    SONAR NOTA_MI4, 2
    SONAR NOTA_DO4, 3
    pop cx
    pop bx
    ret
sonido_trampa endp

; Salida cerrada porque faltan monedas.
sonido_bloqueo proc near
    push bx
    push cx
    SONAR NOTA_GRAVE, 2
    pop cx
    pop bx
    ret
sonido_bloqueo endp

; Victoria: arpegio ascendente.
sonido_victoria proc near
    push bx
    push cx
    SONAR NOTA_DO5, 2
    SONAR NOTA_MI5, 2
    SONAR NOTA_SOL5, 2
    SONAR NOTA_DO6, 5
    pop cx
    pop bx
    ret
sonido_victoria endp

; Derrota: notas descendentes.
sonido_derrota proc near
    push bx
    push cx
    SONAR NOTA_SOL4, 3
    SONAR NOTA_MI4, 3
    SONAR NOTA_DO4, 6
    pop cx
    pop bx
    ret
sonido_derrota endp
endm
