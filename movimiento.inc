; Integrante 2: movimiento original adaptado para la integracion.
DEFINE_MOVIMIENTO macro
; ==========================================
; MOVIMIENTO Y COLISIONES
; ==========================================

procesar_movimiento proc

    push ax
    push bx
    push cx
    push dx
    push si

    cmp estado,1
    je mv_estado_valido
    jmp fin_movimiento
mv_estado_valido:
    mov bl,jugador_x
    mov bh,jugador_y
    ; Teclas extendidas del BIOS, o letras WASD sin distinguir mayusculas.
    cmp ah,48h
    je mover_arriba
    cmp ah,50h
    je mover_abajo
    cmp ah,4Bh
    je mover_izquierda
    cmp ah,4Dh
    je mover_derecha
    cmp al,27
    je regresar_menu
    or al,20h

    cmp al,'w'
    je mover_arriba

    cmp al,'s'
    je mover_abajo

    cmp al,'a'
    je mover_izquierda

    cmp al,'d'
    je mover_derecha

    cmp al,'p'
    je pausar_juego

    cmp al,'q'
    je regresar_menu

    jmp fin_movimiento

mover_arriba:
    dec bh
    jmp verificar_destino

mover_abajo:
    inc bh
    jmp verificar_destino

mover_izquierda:
    dec bl
    jmp verificar_destino

mover_derecha:
    inc bl
    jmp verificar_destino

pausar_juego:
    mov estado,4
    jmp fin_movimiento

regresar_menu:
    mov estado,0
    jmp fin_movimiento

verificar_destino:

    ; Comprobar limites del mapa
    cmp bl,ANCHO
    jae fin_movimiento

    cmp bh,ALTO
    jae fin_movimiento

    ; Calcular indice:
    ; indice = y * ANCHO + x
    xor ax,ax
    mov al,bh

    mov cl,ANCHO
    mul cl

    xor bh,bh
    add ax,bx
    mov si,ax

    ; Revisar pared
    mov al,mapa[si]

    cmp al,'#'
    je fin_movimiento

    ; Revisar salida antes de mover
    cmp al,'S'
    je revisar_salida

    ; Actualizar coordenadas
    mov jugador_x,bl

    mov ax,si
    mov cl,ANCHO
    div cl
    mov jugador_y,al

    call contar_movimiento

    ; Revisar moneda
    cmp byte ptr mapa[si],'C'
    je recoger_moneda

    ; Revisar trampa
    cmp byte ptr mapa[si],'X'
    je activar_trampa

    jmp limpiar_destino

recoger_moneda:
    call sumar_moneda
    jmp limpiar_destino

; Cada trampa se consume una vez. SI conserva la celda de la trampa.
activar_trampa:
    call perder_vida

limpiar_destino:
    mov byte ptr mapa[si],' '
    jmp fin_movimiento

revisar_salida:
    cmp monedas,0
    jne fin_movimiento

    mov jugador_x,bl
    mov ax,si
    mov cl,ANCHO
    div cl
    mov jugador_y,al
    call contar_movimiento
    call ganar_partida

fin_movimiento:

    pop si
    pop dx
    pop cx
    pop bx
    pop ax

    ret

procesar_movimiento endp

contar_movimiento proc near
    cmp movimientos,0FFFFh
    je cm_fin
    inc movimientos
cm_fin:
    ret
contar_movimiento endp
endm
