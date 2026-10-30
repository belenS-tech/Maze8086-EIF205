use16
org 100h
jmp near test_start
file 'MAZE.COM':3
test_start:
push cs
pop ds
mov bp,sp
cld
call 2641
cmp byte [261],3
je @f
jmp fail_0
@@:
cmp byte [262],5
je @f
jmp fail_1
@@:
cmp word [263],0
je @f
jmp fail_2
@@:
mov ax,100
call 2408
cmp byte [259],2
je @f
jmp fail_3
@@:
mov ax,119
call 2408
cmp byte [260],1
je @f
jmp fail_4
@@:
cmp byte [261],3
je @f
jmp fail_5
@@:
mov ax,103
call 2408
cmp byte [259],2
je @f
jmp fail_6
@@:
mov ax,68
call 2408
cmp byte [259],3
je @f
jmp fail_7
@@:
mov ax,19712
call 2408
cmp byte [259],4
je @f
jmp fail_8
@@:
cmp word [263],10
je @f
jmp fail_9
@@:
cmp byte [262],4
je @f
jmp fail_10
@@:
mov ax,97
call 2408
mov ax,100
call 2408
cmp word [263],10
je @f
jmp fail_11
@@:
mov byte [259],0
mov byte [260],1
mov ax,97
call 2408
cmp byte [259],0
je @f
jmp fail_12
@@:
mov byte [259],1
mov byte [260],0
mov ax,119
call 2408
cmp byte [260],0
je @f
jmp fail_13
@@:
mov byte [259],19
mov byte [260],1
mov ax,100
call 2408
cmp byte [259],19
je @f
jmp fail_14
@@:
mov byte [259],1
mov byte [260],14
mov ax,115
call 2408
cmp byte [260],14
je @f
jmp fail_15
@@:
call 2641
mov ax,112
call 2408
cmp byte [269],4
je @f
jmp fail_16
@@:
mov ax,100
call 2408
cmp byte [259],1
je @f
jmp fail_17
@@:
mov byte [269],1
mov ax,113
call 2408
cmp byte [269],0
je @f
jmp fail_18
@@:
call 2641
mov ax,27
call 2408
cmp byte [269],0
je @f
jmp fail_19
@@:
call 2641
mov byte [259],2
mov byte [260],3
mov ax,100
call 2408
cmp byte [261],2
je @f
jmp fail_20
@@:
cmp byte [259],1
je @f
jmp fail_21
@@:
cmp byte [260],1
je @f
jmp fail_22
@@:
mov byte [259],2
mov byte [260],3
mov ax,100
call 2408
cmp byte [261],2
je @f
jmp fail_23
@@:
mov byte [259],9
mov byte [260],7
mov ax,97
call 2408
mov byte [259],16
mov byte [260],11
mov ax,100
call 2408
cmp byte [261],0
je @f
jmp fail_24
@@:
cmp byte [269],3
je @f
jmp fail_25
@@:
mov ax,100
call 2408
cmp byte [261],0
je @f
jmp fail_26
@@:
call 2641
mov byte [259],17
mov byte [260],13
mov ax,100
call 2408
cmp byte [269],1
je @f
jmp fail_27
@@:
cmp byte [259],17
je @f
jmp fail_28
@@:
call 2641
mov ax,100
call 2408
mov ax,100
call 2408
mov ax,100
call 2408
mov ax,100
call 2408
mov ax,100
call 2408
mov ax,115
call 2408
mov ax,115
call 2408
mov ax,100
call 2408
mov ax,100
call 2408
mov ax,119
call 2408
mov ax,119
call 2408
mov ax,100
call 2408
mov ax,100
call 2408
mov ax,100
call 2408
mov ax,100
call 2408
mov ax,100
call 2408
mov ax,97
call 2408
mov ax,97
call 2408
mov ax,97
call 2408
mov ax,97
call 2408
mov ax,97
call 2408
mov ax,115
call 2408
mov ax,115
call 2408
mov ax,115
call 2408
mov ax,115
call 2408
mov ax,97
call 2408
mov ax,97
call 2408
mov ax,97
call 2408
mov ax,97
call 2408
mov ax,97
call 2408
mov ax,97
call 2408
mov ax,97
call 2408
mov ax,115
call 2408
mov ax,115
call 2408
mov ax,115
call 2408
mov ax,115
call 2408
mov ax,115
call 2408
mov ax,115
call 2408
mov ax,115
call 2408
mov ax,115
call 2408
mov ax,100
call 2408
mov ax,100
call 2408
mov ax,100
call 2408
mov ax,100
call 2408
mov ax,100
call 2408
mov ax,100
call 2408
mov ax,100
call 2408
mov ax,119
call 2408
mov ax,119
call 2408
mov ax,119
call 2408
mov ax,119
call 2408
mov ax,100
call 2408
mov ax,100
call 2408
mov ax,100
call 2408
mov ax,97
call 2408
mov ax,97
call 2408
mov ax,97
call 2408
mov ax,115
call 2408
mov ax,115
call 2408
mov ax,115
call 2408
mov ax,115
call 2408
mov ax,97
call 2408
mov ax,97
call 2408
mov ax,97
call 2408
mov ax,97
call 2408
mov ax,100
call 2408
mov ax,100
call 2408
mov ax,100
call 2408
mov ax,100
call 2408
mov ax,100
call 2408
mov ax,100
call 2408
mov ax,119
call 2408
mov ax,119
call 2408
mov ax,100
call 2408
mov ax,100
call 2408
mov ax,100
call 2408
mov ax,100
call 2408
mov ax,115
call 2408
mov ax,115
call 2408
mov ax,100
call 2408
mov ax,100
call 2408
mov ax,100
call 2408
mov ax,100
call 2408
cmp byte [269],2
je @f
jmp fail_29
@@:
cmp word [263],100
je @f
jmp fail_30
@@:
cmp word [265],100
je @f
jmp fail_31
@@:
cmp byte [261],3
je @f
jmp fail_32
@@:
cmp byte [259],18
je @f
jmp fail_33
@@:
call 2777
cmp word [263],100
je @f
jmp fail_34
@@:
call 2641
cmp word [265],100
je @f
jmp fail_35
@@:
cmp word [263],0
je @f
jmp fail_36
@@:
cmp word [267],0
je @f
jmp fail_37
@@:
push ds
pop es
mov si,270
mov di,570
mov cx,300
cld
repe cmpsb
je @f
jmp fail_38
@@:
call 1544
call 1837
mov ax,0B800h
mov es,ax
cmp word [es:1134],3904
je @f
jmp fail_39
@@:
cmp word [es:970],2523
je @f
jmp fail_40
@@:
cmp word [es:1146],3651
je @f
jmp fail_41
@@:
cmp word [es:1462],3160
je @f
jmp fail_42
@@:
cmp word [es:3122],2643
je @f
jmp fail_43
@@:
mov byte [269],4
call 2384
cmp byte [es:1188],80
je @f
jmp fail_44
@@:
mov byte [269],2
call 2392
cmp byte [es:1162],76
je @f
jmp fail_45
@@:
mov byte [269],3
call 2400
cmp byte [es:1162],70
je @f
jmp fail_46
@@:
mov byte [2968],0E9h
mov word [2969],volver_menu-2968-3
mov cx,49
mov ah,5
int 16h
cmp al,0
je @f
jmp fail_47
@@:
mov cx,112
mov ah,5
int 16h
cmp al,0
je @f
jmp fail_48
@@:
mov cx,100
mov ah,5
int 16h
cmp al,0
je @f
jmp fail_49
@@:
mov cx,13
mov ah,5
int 16h
cmp al,0
je @f
jmp fail_50
@@:
mov cx,100
mov ah,5
int 16h
cmp al,0
je @f
jmp fail_51
@@:
mov cx,113
mov ah,5
int 16h
cmp al,0
je @f
jmp fail_52
@@:
mov cx,27
mov ah,5
int 16h
cmp al,0
je @f
jmp fail_53
@@:
jmp 2828
volver_menu:
cmp byte [259],2
je @f
jmp fail_54
@@:
cmp word [267],1
je @f
jmp fail_55
@@:
cmp byte [269],0
je @f
jmp fail_56
@@:
mov byte [269],2
mov byte [261],0
mov word [263],42
mov byte [2968],0E9h
mov word [2969],volver_final_2-2968-3
mov cx,114
mov ah,5
int 16h
cmp al,0
je @f
jmp fail_57
@@:
mov cx,113
mov ah,5
int 16h
cmp al,0
je @f
jmp fail_58
@@:
mov cx,27
mov ah,5
int 16h
cmp al,0
je @f
jmp fail_59
@@:
jmp 2941
volver_final_2:
cmp byte [261],3
je @f
jmp fail_60
@@:
cmp word [263],0
je @f
jmp fail_61
@@:
cmp word [265],100
je @f
jmp fail_62
@@:
mov byte [269],3
mov byte [261],0
mov word [263],42
mov byte [2968],0E9h
mov word [2969],volver_final_3-2968-3
mov cx,114
mov ah,5
int 16h
cmp al,0
je @f
jmp fail_63
@@:
mov cx,113
mov ah,5
int 16h
cmp al,0
je @f
jmp fail_64
@@:
mov cx,27
mov ah,5
int 16h
cmp al,0
je @f
jmp fail_65
@@:
jmp 2941
volver_final_3:
cmp byte [261],3
je @f
jmp fail_66
@@:
cmp word [263],0
je @f
jmp fail_67
@@:
cmp word [265],100
je @f
jmp fail_68
@@:
cmp sp,bp
je @f
jmp fail_69
@@:
call 1561
mov dx,success
mov ah,9
int 21h
mov ax,4C00h
int 21h
fail_0:
call 1561
mov dx,msg_0
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_0 db 'FAIL 1: inicio: tres vidas',13,10,'$'
fail_1:
call 1561
mov dx,msg_1
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_1 db 'FAIL 2: inicio: cinco monedas',13,10,'$'
fail_2:
call 1561
mov dx,msg_2
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_2 db 'FAIL 3: inicio: cero puntos',13,10,'$'
fail_3:
call 1561
mov dx,msg_3
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_3 db 'FAIL 4: WASD: avanza una celda',13,10,'$'
fail_4:
call 1561
mov dx,msg_4
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_4 db 'FAIL 5: pared: bloquea el movimiento',13,10,'$'
fail_5:
call 1561
mov dx,msg_5
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_5 db 'FAIL 6: pared: conserva las vidas',13,10,'$'
fail_6:
call 1561
mov dx,msg_6
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_6 db 'FAIL 7: tecla no asignada: ignorada',13,10,'$'
fail_7:
call 1561
mov dx,msg_7
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_7 db 'FAIL 8: WASD en mayuscula',13,10,'$'
fail_8:
call 1561
mov dx,msg_8
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_8 db 'FAIL 9: flecha derecha',13,10,'$'
fail_9:
call 1561
mov dx,msg_9
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_9 db 'FAIL 10: moneda suma diez',13,10,'$'
fail_10:
call 1561
mov dx,msg_10
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_10 db 'FAIL 11: moneda reduce pendientes',13,10,'$'
fail_11:
call 1561
mov dx,msg_11
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_11 db 'FAIL 12: moneda no se cobra dos veces',13,10,'$'
fail_12:
call 1561
mov dx,msg_12
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_12 db 'FAIL 13: limite izquierdo sin desbordamiento',13,10,'$'
fail_13:
call 1561
mov dx,msg_13
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_13 db 'FAIL 14: limite superior sin desbordamiento',13,10,'$'
fail_14:
call 1561
mov dx,msg_14
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_14 db 'FAIL 15: limite derecho sin desbordamiento',13,10,'$'
fail_15:
call 1561
mov dx,msg_15
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_15 db 'FAIL 16: limite inferior sin desbordamiento',13,10,'$'
fail_16:
call 1561
mov dx,msg_16
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_16 db 'FAIL 17: P activa pausa',13,10,'$'
fail_17:
call 1561
mov dx,msg_17
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_17 db 'FAIL 18: pausa bloquea movimiento',13,10,'$'
fail_18:
call 1561
mov dx,msg_18
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_18 db 'FAIL 19: Q vuelve al menu',13,10,'$'
fail_19:
call 1561
mov dx,msg_19
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_19 db 'FAIL 20: ESC vuelve al menu',13,10,'$'
fail_20:
call 1561
mov dx,msg_20
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_20 db 'FAIL 21: trampa resta una vida',13,10,'$'
fail_21:
call 1561
mov dx,msg_21
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_21 db 'FAIL 22: trampa devuelve al inicio X',13,10,'$'
fail_22:
call 1561
mov dx,msg_22
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_22 db 'FAIL 23: trampa devuelve al inicio Y',13,10,'$'
fail_23:
call 1561
mov dx,msg_23
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_23 db 'FAIL 24: trampa se consume una sola vez',13,10,'$'
fail_24:
call 1561
mov dx,msg_24
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_24 db 'FAIL 25: tercera trampa agota vidas',13,10,'$'
fail_25:
call 1561
mov dx,msg_25
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_25 db 'FAIL 26: cero vidas activa derrota',13,10,'$'
fail_26:
call 1561
mov dx,msg_26
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_26 db 'FAIL 27: derrota no desborda vidas',13,10,'$'
fail_27:
call 1561
mov dx,msg_27
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_27 db 'FAIL 28: salida bloqueada con monedas pendientes',13,10,'$'
fail_28:
call 1561
mov dx,msg_28
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_28 db 'FAIL 29: salida bloqueada no cambia posicion',13,10,'$'
fail_29:
call 1561
mov dx,msg_29
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_29 db 'FAIL 30: recorrido completo llega a victoria',13,10,'$'
fail_30:
call 1561
mov dx,msg_30
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_30 db 'FAIL 31: cinco monedas y bonus de salida',13,10,'$'
fail_31:
call 1561
mov dx,msg_31
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_31 db 'FAIL 32: record actualizado',13,10,'$'
fail_32:
call 1561
mov dx,msg_32
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_32 db 'FAIL 33: victoria sin atravesar trampas',13,10,'$'
fail_33:
call 1561
mov dx,msg_33
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_33 db 'FAIL 34: victoria coloca al jugador en salida',13,10,'$'
fail_34:
call 1561
mov dx,msg_34
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_34 db 'FAIL 35: bonus de victoria no se repite',13,10,'$'
fail_35:
call 1561
mov dx,msg_35
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_35 db 'FAIL 36: reiniciar conserva record',13,10,'$'
fail_36:
call 1561
mov dx,msg_36
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_36 db 'FAIL 37: reiniciar borra puntuacion',13,10,'$'
fail_37:
call 1561
mov dx,msg_37
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_37 db 'FAIL 38: reiniciar borra movimientos',13,10,'$'
fail_38:
call 1561
mov dx,msg_38
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_38 db 'FAIL 39: reiniciar restaura mapa completo',13,10,'$'
fail_39:
call 1561
mov dx,msg_39
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_39 db 'FAIL 40: jugador visible',13,10,'$'
fail_40:
call 1561
mov dx,msg_40
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_40 db 'FAIL 41: pared azul',13,10,'$'
fail_41:
call 1561
mov dx,msg_41
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_41 db 'FAIL 42: moneda amarilla',13,10,'$'
fail_42:
call 1561
mov dx,msg_42
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_42 db 'FAIL 43: trampa roja',13,10,'$'
fail_43:
call 1561
mov dx,msg_43
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_43 db 'FAIL 44: salida verde',13,10,'$'
fail_44:
call 1561
mov dx,msg_44
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_44 db 'FAIL 45: pantalla de pausa',13,10,'$'
fail_45:
call 1561
mov dx,msg_45
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_45 db 'FAIL 46: pantalla de victoria',13,10,'$'
fail_46:
call 1561
mov dx,msg_46
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_46 db 'FAIL 47: pantalla de derrota',13,10,'$'
fail_47:
call 1561
mov dx,msg_47
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_47 db 'FAIL 48: BIOS acepta tecla para prueba de estados',13,10,'$'
fail_48:
call 1561
mov dx,msg_48
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_48 db 'FAIL 49: BIOS acepta tecla para prueba de estados',13,10,'$'
fail_49:
call 1561
mov dx,msg_49
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_49 db 'FAIL 50: BIOS acepta tecla para prueba de estados',13,10,'$'
fail_50:
call 1561
mov dx,msg_50
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_50 db 'FAIL 51: BIOS acepta tecla para prueba de estados',13,10,'$'
fail_51:
call 1561
mov dx,msg_51
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_51 db 'FAIL 52: BIOS acepta tecla para prueba de estados',13,10,'$'
fail_52:
call 1561
mov dx,msg_52
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_52 db 'FAIL 53: BIOS acepta tecla para prueba de estados',13,10,'$'
fail_53:
call 1561
mov dx,msg_53
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_53 db 'FAIL 54: BIOS acepta tecla para prueba de estados',13,10,'$'
fail_54:
call 1561
mov dx,msg_54
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_54 db 'FAIL 55: bucle real: pausa ignora D y ENTER reanuda',13,10,'$'
fail_55:
call 1561
mov dx,msg_55
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_55 db 'FAIL 56: bucle real: solo cuenta movimiento fuera de pausa',13,10,'$'
fail_56:
call 1561
mov dx,msg_56
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_56 db 'FAIL 57: bucle real: Q devuelve al menu y ESC sale',13,10,'$'
fail_57:
call 1561
mov dx,msg_57
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_57 db 'FAIL 58: BIOS acepta tecla para prueba de estados',13,10,'$'
fail_58:
call 1561
mov dx,msg_58
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_58 db 'FAIL 59: BIOS acepta tecla para prueba de estados',13,10,'$'
fail_59:
call 1561
mov dx,msg_59
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_59 db 'FAIL 60: BIOS acepta tecla para prueba de estados',13,10,'$'
fail_60:
call 1561
mov dx,msg_60
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_60 db 'FAIL 61: bucle real: R reinicia tras estado 2',13,10,'$'
fail_61:
call 1561
mov dx,msg_61
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_61 db 'FAIL 62: bucle real: R borra puntos tras estado 2',13,10,'$'
fail_62:
call 1561
mov dx,msg_62
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_62 db 'FAIL 63: bucle real: R conserva record tras estado 2',13,10,'$'
fail_63:
call 1561
mov dx,msg_63
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_63 db 'FAIL 64: BIOS acepta tecla para prueba de estados',13,10,'$'
fail_64:
call 1561
mov dx,msg_64
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_64 db 'FAIL 65: BIOS acepta tecla para prueba de estados',13,10,'$'
fail_65:
call 1561
mov dx,msg_65
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_65 db 'FAIL 66: BIOS acepta tecla para prueba de estados',13,10,'$'
fail_66:
call 1561
mov dx,msg_66
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_66 db 'FAIL 67: bucle real: R reinicia tras estado 3',13,10,'$'
fail_67:
call 1561
mov dx,msg_67
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_67 db 'FAIL 68: bucle real: R borra puntos tras estado 3',13,10,'$'
fail_68:
call 1561
mov dx,msg_68
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_68 db 'FAIL 69: bucle real: R conserva record tras estado 3',13,10,'$'
fail_69:
call 1561
mov dx,msg_69
mov ah,9
int 21h
mov ax,4C01h
int 21h
msg_69 db 'FAIL 70: pila balanceada tras todas las llamadas',13,10,'$'
success db 'PASS: 70 comprobaciones sobre el COM de EMU8086',13,10,'$'
