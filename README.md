# Maze8086 - juego integrado

Juego en ensamblador 8086 para EIF205. Los tres modulos del equipo estan
conectados: interfaz, movimiento/colisiones y reglas de partida.

## Abrir el juego

Con DOSBox-X instalado en `C:\DOSBox-X`, ejecutar **JUGAR.bat** con doble clic.
El lanzador abre `build/MAZE.COM` y monta solamente la carpeta `build`.
La ruta relativa del archivo de configuracion evita problemas con tildes en
el nombre del usuario de Windows. Es necesario conservar `build/play.conf`.

Alternativa dentro de DOSBox-X para esta computadora:

```dos
mount c "C:\Users\BELN~1\Documents\2026\Arqui\Maze8086\build"
c:
MAZE.COM
```

En otra computadora, sustituir la ruta por la carpeta `build` correspondiente.
El comando `mount c "."` de `play.conf` presupone que DOSBox se abre con
`build` como directorio de trabajo; `JUGAR.bat` ya hace esto.

## Reglas y controles

Recoger las cinco monedas y llegar a la salida S. Cada moneda suma 10 puntos
y la salida suma 50: una partida ganada obtiene 100 puntos. Las paredes
bloquean el paso y no quitan vidas. Cada trampa X quita una de las tres vidas,
devuelve al jugador al inicio y desaparece. Tres trampas causan derrota.

| Pantalla | Teclas |
| --- | --- |
| Menu | 1 inicia una partida; ESC cierra el programa |
| Partida | Flechas o WASD mueven; P pausa; Q o ESC vuelven al menu |
| Pausa | P o Enter continuan; Q o ESC vuelven al menu |
| Victoria o derrota | R reinicia; M o Q vuelven al menu; ESC sale |

WASD, P, Q, R y M aceptan mayusculas y minusculas. No hay movimiento automatico
ni limite de tiempo: cada tecla de movimiento intenta avanzar una celda.
El contador registra movimientos validos, incluida la entrada a una trampa
o a la salida. Una pared no cuenta como movimiento.

El record se actualiza al sumar puntos y se conserva entre partidas mientras
el programa sigue abierto. **No se guarda en disco al cerrar el programa.**

## Compilar con EMU8086

1. Mantener `maze.asm`, `interfaz.inc`, `movimiento.inc` y `juego.inc` juntos.
2. Abrir `maze.asm` en EMU8086 y pulsar Compile.
3. Guardar el COM como `build/MAZE.COM`, reemplazando el binario anterior.
4. Cerrar la partida anterior de DOSBox y volver a ejecutar `JUGAR.bat`.

EMU8086 4.08 compilo esta version en cuatro pasadas: **2720 bytes**.
La ejecucion se verifico en DOSBox-X 2026.10.01. Los INC usan saltos CRLF.
EMU8086 importa las macros `DEFINE_INTERFACE`, `DEFINE_MOVIMIENTO` y
`DEFINE_JUEGO`; cada una se invoca una vez desde el archivo principal.
El salto inicial evita ejecutar los datos o entrar por accidente en rutinas.

## Arquitectura y contribuciones

| Archivo | Responsabilidad |
| --- | --- |
| `maze.asm` | Datos compartidos, mapa y bucle de estados/teclado |
| `interfaz.inc` | Interfaz del integrante 1, adaptada a los datos compartidos |
| `movimiento.inc` | Movimiento del integrante 2, con soporte de flechas, mayusculas y contador |
| `juego.inc` | Reglas del integrante 3: vidas, monedas, puntos, record, victoria y reinicio |

La integracion parte de los commits del equipo: movimiento `de2a902`, juego
`462dd2a` e interfaz `8aee279`. Se conservan sus rutinas, unificando nombres,
simbolos del mapa y llamadas. Se agregaron protecciones para impedir cambios
de partida o bonificaciones repetidas despues del final.

Datos compartidos: `jugador_x`, `jugador_y`, `vidas`, `monedas` y `estado` son
bytes; `puntos`, `record_max` y `movimientos` son words sin signo. El estado
vale 0 para menu, 1 partida, 2 victoria, 3 derrota y 4 pausa.
`mapa_original` y `mapa` tienen 300 bytes cada uno (20 columnas por 15 filas).
Los simbolos son # pared, espacio pasillo, C moneda, X trampa y S salida.
El jugador @ se dibuja encima del mapa sin modificar su contenido.

El COM comparte segmento para codigo/datos y usa la pila del entorno DOS.
La interfaz escribe en B800h en modo texto 03h; BIOS INT 16h espera teclado
y DOS INT 21h devuelve el control al sistema al salir. El mapa se copia con
DS:SI y ES:DI, preservando registros y ES. No utiliza dispositivos exclusivos
del emulador de EMU8086 ni instrucciones posteriores al 8086.

## Pruebas

Ver `tests/BITACORA.md`. El arnes llama al codigo maquina real de MAZE.COM,
usando las direcciones de su tabla de simbolos, y se ejecuta en DOSBox-X.
No sustituye las rutinas por una simulacion en Python.

Para repetirlo, guardar tambien la tabla `MAZE.COM.symbol` de la misma
compilacion, y ejecutar desde la raiz del proyecto:

```text
python tests/preparar_pruebas.py
C:\emu8086\fasm\FASM.EXE build\TEST.ASM build\TEST.COM
```

En DOSBox, montar `build` y ejecutar `TEST.COM`. FASM solo ensambla el arnes;
el juego que este comprueba sigue siendo el COM producido por EMU8086.
Resultado verificado: **PASS: 70 comprobaciones sobre el COM de EMU8086**.

El informe tecnico extenso y la presentacion del grupo deben completarse
con su explicacion, conclusiones y evidencias; este README no los reemplaza.
