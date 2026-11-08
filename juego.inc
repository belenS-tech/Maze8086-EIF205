; Integrante 3: reglas, record en memoria entre partidas y cronometro.
DEFINE_JUEGO macro
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
    mov movimientos,0
    mov segundos,0
    mov ticks_partida,0
    mov estado,1
    call iniciar_reloj

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

    cmp estado,1
    jne fin_moneda
    cmp monedas,0
    je fin_moneda

    dec monedas
    add puntos,10

    call actualizar_record
    call sonido_moneda

fin_moneda:
    pop ax
    ret
sumar_moneda endp

; Restar vida al caer en trampa
perder_vida proc
    push ax

    cmp estado,1
    jne fin_perder_vida
    cmp vidas,0
    je pv_derrota

    dec vidas

    cmp vidas,0
    je pv_derrota

    ; Regresar al inicio
    mov jugador_x,1
    mov jugador_y,1
    call sonido_trampa
    jmp fin_perder_vida

pv_derrota:
    mov estado,3
    call sonido_derrota

fin_perder_vida:
    pop ax
    ret
perder_vida endp

; Completar el laberinto
ganar_partida proc
    push ax

    cmp estado,1
    jne fin_ganar
    cmp monedas,0
    jne fin_ganar

    call actualizar_tiempo  ; tomar el tiempo final antes del bono
    add puntos,50

    ; Bono de tiempo: TIEMPO_BONO menos los segundos usados, si es positivo.
    mov ax,TIEMPO_BONO
    sub ax,segundos
    jbe gp_sin_bono         ; CF=1 o ZF=1: se pasaron los segundos de referencia
    add puntos,ax
gp_sin_bono:
    call actualizar_record
    mov estado,2
    call sonido_victoria

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

; ==========================================
; CRONOMETRO
; INT 1Ah/00h devuelve en CX:DX los ticks desde medianoche (18.2 por
; segundo). Solo se usa la palabra baja (DX): la resta de dos lecturas
; da el tiempo transcurrido aunque DX haya dado la vuelta.
; ==========================================

; Toma la lectura actual como punto de partida. Se llama al iniciar o
; reanudar una partida para no contar el tiempo en menu o pausa.
iniciar_reloj proc near
    push ax
    push cx
    push dx
    mov ah,0
    int 1Ah
    mov tick_anterior,dx
    pop dx
    pop cx
    pop ax
    ret
iniciar_reloj endp

; Acumula los ticks transcurridos y, si cambio el segundo, redibuja
; solo el reloj del marcador. No hace nada fuera del estado de partida.
actualizar_tiempo proc near
    push ax
    push bx
    push cx
    push dx

    cmp estado,1
    jne at_fin

    mov ah,0
    int 1Ah                 ; CX:DX = ticks actuales
    mov ax,dx
    sub ax,tick_anterior    ; AX = ticks desde la lectura anterior
    mov tick_anterior,dx
    cmp ax,TICKS_MAX_SALTO
    ja at_fin               ; salto anormal: no se suma

    add ticks_partida,ax
    jnc at_calcular
    mov ticks_partida,0FFFFh ; tope de una hora

at_calcular:
    ; segundos = ticks * 10 / 182  (18.2 ticks por segundo)
    mov ax,ticks_partida
    mov bx,10
    mul bx                  ; DX:AX = ticks * 10
    mov bx,182
    div bx                  ; AX = segundos (maximo 3600)
    cmp ax,segundos
    je at_fin
    mov segundos,ax
    call ui_tiempo

at_fin:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
actualizar_tiempo endp
endm
