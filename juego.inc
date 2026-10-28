; Preparar una partida nueva
reiniciar_juego proc
    push ax
    push cx
    push si
    push di
    push es

    ; Copiar mapa original
    push ds
    pop es

    lea si,mapa_original
    lea di,mapa

    mov cx,TOTAL
    cld
    rep movsb

    mov jugador_x,1
    mov jugador_y,1

    mov vidas,3
    mov monedas,MONEDAS_TOTAL
    mov puntos,0
    mov estado,1

    pop es
    pop di
    pop si
    pop cx
    pop ax
    ret
reiniciar_juego endp

; Sumar puntos por moneda
sumar_moneda proc
    push ax

    cmp monedas,0
    je fin_moneda

    dec monedas
    add puntos,10

    call actualizar_record

fin_moneda:
    pop ax
    ret
sumar_moneda endp

; Restar vida al caer en trampa
perder_vida proc
    push ax

    cmp vidas,0
    je pv_derrota

    dec vidas

    cmp vidas,0
    je pv_derrota

    ; Regresar al inicio
    mov jugador_x,1
    mov jugador_y,1
    jmp fin_perder_vida

pv_derrota:
    mov estado,3

fin_perder_vida:
    pop ax
    ret
perder_vida endp

; Completar el laberinto
ganar_partida proc
    push ax

    cmp monedas,0
    jne fin_ganar

    add puntos,50
    call actualizar_record
    mov estado,2

fin_ganar:
    pop ax
    ret
ganar_partida endp

; Guardar mejor puntuacion
actualizar_record proc
    push ax

    mov ax,puntos

    cmp ax,record_max
    jbe fin_record

    mov record_max,ax

fin_record:
    pop ax
    ret
actualizar_record endp