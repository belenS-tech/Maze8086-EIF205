"""Genera un COM de pruebas que llama al codigo REAL compilado por EMU8086.

Requiere build/MAZE.COM y build/MAZE.COM.symbol de la misma compilacion.
El arnes se ensambla con FASM; no recompila ni simula las rutinas del juego.
"""
from collections import deque
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
BUILD = ROOT / 'build'
symbols = {}
for line in (BUILD / 'MAZE.COM.symbol').read_text().splitlines():
    match = re.match(r'^(\w+)\s+([0-9A-F]+)\s+-?\d+\s+(VAR|NEAR|LABEL)', line, re.I)
    if match:
        symbols[match[1].lower()] = int(match[2], 16)

rows = [line.split("'")[1] for line in (ROOT/'maze.asm').read_text().splitlines()
        if line.startswith(('mapa_original db', '              db'))]
assert len(rows) == 15 and all(len(row) == 20 for row in rows)
assert sum(row.count('C') for row in rows) == 5
assert sum(row.count('X') for row in rows) == 3

code = ['use16', 'org 100h', 'jmp near test_start', "file 'MAZE.COM':3", 'test_start:',
        'push cs', 'pop ds', 'mov bp,sp', 'cld']
checks = []

def emit(*lines):
    code.extend(lines)

def call(name):
    emit(f'call {symbols[name]}')

def memory(name, size='byte'):
    return f'{size} [{symbols[name]}]'

def setvar(name, value, size='byte'):
    emit(f'mov {memory(name,size)},{value}')

def check(operand, expected, description):
    index = len(checks)
    checks.append(description)
    emit(f'cmp {operand},{expected}', 'je @f', f'jmp fail_{index}', '@@:')

def expect(name, value, description, size='byte'):
    check(memory(name,size), value, description)

def key(value):
    emit(f'mov ax,{ord(value) if isinstance(value,str) else value}')
    call('procesar_movimiento')

def position(x,y):
    setvar('jugador_x',x)
    setvar('jugador_y',y)

call('reiniciar_juego')
expect('vidas',3,'inicio: tres vidas')
expect('monedas',5,'inicio: cinco monedas')
expect('puntos',0,'inicio: cero puntos','word')
key('d')
expect('jugador_x',2,'WASD: avanza una celda')
key('w')
expect('jugador_y',1,'pared: bloquea el movimiento')
expect('vidas',3,'pared: conserva las vidas')
key('g')
expect('jugador_x',2,'tecla no asignada: ignorada')
key('D')
expect('jugador_x',3,'WASD en mayuscula')
key(0x4D00)
expect('jugador_x',4,'flecha derecha')
expect('puntos',10,'moneda suma diez','word')
expect('monedas',4,'moneda reduce pendientes')
key('a'); key('d')
expect('puntos',10,'moneda no se cobra dos veces','word')
position(0,1); key('a')
expect('jugador_x',0,'limite izquierdo sin desbordamiento')
position(1,0); key('w')
expect('jugador_y',0,'limite superior sin desbordamiento')
position(19,1); key('d')
expect('jugador_x',19,'limite derecho sin desbordamiento')
position(1,14); key('s')
expect('jugador_y',14,'limite inferior sin desbordamiento')
call('reiniciar_juego')
key('p')
expect('estado',4,'P activa pausa')
key('d')
expect('jugador_x',1,'pausa bloquea movimiento')
setvar('estado',1); key('q')
expect('estado',0,'Q vuelve al menu')
call('reiniciar_juego'); key(27)
expect('estado',0,'ESC vuelve al menu')
call('reiniciar_juego')
position(2,3); key('d')
expect('vidas',2,'trampa resta una vida')
expect('jugador_x',1,'trampa devuelve al inicio X')
expect('jugador_y',1,'trampa devuelve al inicio Y')
position(2,3); key('d')
expect('vidas',2,'trampa se consume una sola vez')
position(9,7); key('a')
position(16,11); key('d')
expect('vidas',0,'tercera trampa agota vidas')
expect('estado',3,'cero vidas activa derrota')
key('d')
expect('vidas',0,'derrota no desborda vidas')
call('reiniciar_juego')
position(17,13); key('d')
expect('estado',1,'salida bloqueada con monedas pendientes')
expect('jugador_x',17,'salida bloqueada no cambia posicion')
call('reiniciar_juego')

def path(start, goal):
    queue = deque([(start, '')]); seen = {start}
    while queue:
        (x,y), route = queue.popleft()
        if (x,y) == goal:
            return route
        for dx,dy,k in ((1,0,'d'),(-1,0,'a'),(0,1,'s'),(0,-1,'w')):
            nx,ny = x+dx,y+dy
            if (0 <= nx < 20 and 0 <= ny < 15 and rows[ny][nx] not in '#X'
                    and (nx,ny) not in seen):
                seen.add((nx,ny)); queue.append(((nx,ny),route+k))
    raise AssertionError(f'Objetivo inaccesible sin trampas: {goal}')

current = (1,1)
for goal in [(x,y) for y,row in enumerate(rows) for x,c in enumerate(row) if c=='C'] + [(18,13)]:
    for k in path(current,goal):
        key(k)
    current = goal
expect('estado',2,'recorrido completo llega a victoria')
expect('puntos',100,'cinco monedas y bonus de salida','word')
expect('record_max',100,'record actualizado','word')
expect('vidas',3,'victoria sin atravesar trampas')
expect('jugador_x',18,'victoria coloca al jugador en salida')
call('ganar_partida')
expect('puntos',100,'bonus de victoria no se repite','word')
call('reiniciar_juego')
expect('record_max',100,'reiniciar conserva record','word')
expect('puntos',0,'reiniciar borra puntuacion','word')
expect('movimientos',0,'reiniciar borra movimientos','word')
emit('push ds','pop es',f'mov si,{symbols["mapa_original"]}',
     f'mov di,{symbols["mapa"]}','mov cx,300','cld','repe cmpsb')
index=len(checks); checks.append('reiniciar restaura mapa completo')
emit('je @f',f'jmp fail_{index}','@@:')

# Comprueba que el dibujo usa realmente el mapa y los datos compartidos.
call('ui_init'); call('ui_board')
emit('mov ax,0B800h','mov es,ax')
for x,y,char,attr,description in [(7,7,'@',15,'jugador visible'),(5,6,219,9,'pared azul'),
        (13,7,'C',14,'moneda amarilla'),(11,9,'X',12,'trampa roja'),
        (41,19,'S',10,'salida verde')]:
    value=(ord(char) if isinstance(char,str) else char)+256*attr
    check(f'word [es:{y*160+x*2}]',value,description)
setvar('estado',4); call('ui_pause')
check('byte [es:1188]',ord('P'),'pantalla de pausa')
setvar('estado',2); call('ui_win')
check('byte [es:1162]',ord('L'),'pantalla de victoria')
setvar('estado',3); call('ui_lose')
check('byte [es:1162]',ord('F'),'pantalla de derrota')

# Ejecuta tambien los manejadores originales de teclado/estados. Solo el
# punto de salida se redirige al arnes para poder comprobar el resultado.
def run_loop(entry, keys, label):
    emit(f'mov byte [{symbols["salir"]}],0E9h',
         f'mov word [{symbols["salir"]+1}],{label}-{symbols["salir"]}-3')
    for value in keys:
        emit(f'mov cx,{ord(value) if isinstance(value,str) else value}',
             'mov ah,5','int 16h')
        check('al',0,'BIOS acepta tecla para prueba de estados')
    emit(f'jmp {symbols[entry]}',label+':')

run_loop('mostrar_menu',['1','p','d',13,'d','q',27],'volver_menu')
expect('jugador_x',2,'bucle real: pausa ignora D y ENTER reanuda')
expect('movimientos',1,'bucle real: solo cuenta movimiento fuera de pausa','word')
expect('estado',0,'bucle real: Q devuelve al menu y ESC sale')
for state in (2,3):
    setvar('estado',state)
    setvar('vidas',0)
    setvar('puntos',42,'word')
    run_loop('esperar_final',['r','q',27],f'volver_final_{state}')
    expect('vidas',3,f'bucle real: R reinicia tras estado {state}')
    expect('puntos',0,f'bucle real: R borra puntos tras estado {state}','word')
    expect('record_max',100,f'bucle real: R conserva record tras estado {state}','word')

check('sp','bp','pila balanceada tras todas las llamadas')
call('ui_shutdown')
emit('mov dx,success','mov ah,9','int 21h','mov ax,4C00h','int 21h')
for index,description in enumerate(checks):
    emit(f'fail_{index}:')
    call('ui_shutdown')
    emit(f'mov dx,msg_{index}','mov ah,9','int 21h','mov ax,4C01h','int 21h',
         f"msg_{index} db 'FAIL {index+1}: {description}',13,10,'$'")
emit(f"success db 'PASS: {len(checks)} comprobaciones sobre el COM de EMU8086',13,10,'$'")
(BUILD/'TEST.ASM').write_text('\n'.join(code)+'\n', encoding='ascii')
(BUILD/'casos.txt').write_text('\n'.join(f'{i+1}. {d}' for i,d in enumerate(checks))+'\n')
print(f'Generado build/TEST.ASM: {len(checks)} comprobaciones sobre MAZE.COM.')
