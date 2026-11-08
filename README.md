# Maze8086 - juego integrado

Juego de laberinto en ensamblador 8086 para EIF205. Los modulos del equipo
estan conectados: interfaz, movimiento/colisiones, reglas de partida con
cronometro y efectos de sonido.

## Abrir el juego

Con DOSBox-X instalado en `C:\DOSBox-X`, ejecutar **JUGAR.bat** con doble clic.
El lanzador abre `build/MAZE.COM` y monta solamente la carpeta `build`.
La ruta relativa del archivo de configuracion evita problemas con tildes en
el nombre del usuario de Windows. Es necesario conservar `build/play.conf`.

Alternativa manual dentro de DOSBox-X (sustituir la ruta por la carpeta
`build` de cada computadora):

```dos
mount c "C:\ruta\al\proyecto\Maze8086\build"
c:
MAZE.COM
```

## Reglas y controles

Recoger las cinco monedas y llegar a la salida S. Cada moneda suma 10 puntos
y la salida suma 50. Al ganar se agrega un bono de tiempo: 120 menos los
segundos usados (si se tarda 120 segundos o mas, el bono es 0). Una partida
ganada obtiene entre 100 y 220 puntos.

Las paredes bloquean el paso y no quitan vidas. Cada trampa X quita una de
las tres vidas, devuelve al jugador al inicio y desaparece. Tres trampas
causan derrota. Si se intenta entrar a la salida con monedas pendientes, el
jugador no se mueve y suena un tono grave.

| Pantalla | Teclas |
| --- | --- |
| Menu | 1 inicia una partida; ESC cierra el programa |
| Partida | Flechas o WASD mueven; P pausa; Q o ESC vuelven al menu |
| Pausa | P o Enter continuan; Q o ESC vuelven al menu |
| Victoria o derrota | R reinicia; M o Q vuelven al menu; ESC sale |

WASD, P, Q, R y M aceptan mayusculas y minusculas. Cada tecla de movimiento
intenta avanzar una celda. El contador registra movimientos validos,
incluida la entrada a una trampa o a la salida. Una pared no cuenta.

El cronometro avanza solo durante la partida: no cuenta el tiempo en el menu
ni en la pausa. Se muestra en el marcador y en las pantallas finales.

El record se actualiza al sumar puntos y se conserva entre partidas mientras
el programa sigue abierto. **No se guarda en disco al cerrar el programa.**

## Sonido

El juego usa el parlante del PC (canal 2 del temporizador, puertos 42h, 43h
y 61h). Hay sonidos para moneda, trampa, salida cerrada, victoria y derrota.
En DOSBox-X se escuchan. Es posible que el emulador de EMU8086 no reproduzca
el parlante; en ese caso el juego funciona igual, sin sonido.

## Compilar con EMU8086

1. Mantener `maze.asm`, `interfaz.inc`, `movimiento.inc`, `juego.inc` y
   `sonido.inc` juntos.
2. Abrir `maze.asm` en EMU8086 y pulsar Compile.
3. Guardar el COM como `build/MAZE.COM`, reemplazando el binario anterior.
4. Cerrar la partida anterior de DOSBox y volver a ejecutar `JUGAR.bat`.

El juego se compila como COM con EMU8086 4.08 y se ejecuta en DOSBox-X
2026.10.01. Los INC usan saltos CRLF. EMU8086 importa las macros
`DEFINE_INTERFACE`, `DEFINE_MOVIMIENTO`, `DEFINE_JUEGO` y `DEFINE_SONIDO`;
cada una se invoca una vez desde el archivo principal. El salto inicial
evita ejecutar los datos o entrar por accidente en rutinas.

## Arquitectura

| Archivo | Responsabilidad |
| --- | --- |
| `maze.asm` | Datos compartidos, mapa y bucle de estados/teclado |
| `interfaz.inc` | Menu, tablero, marcador con reloj, pausa y pantallas finales |
| `movimiento.inc` | Teclado, limites y colisiones |
| `juego.inc` | Vidas, monedas, puntos, record, victoria, reinicio y cronometro |
| `sonido.inc` | Macro `SONAR` y efectos con el parlante del PC |

Datos compartidos: `puntos`, `record_max`, `movimientos`, `segundos`,
`ticks_partida` y `tick_anterior` son words sin signo; `jugador_x`,
`jugador_y`, `vidas`, `monedas` y `estado` son bytes. Un byte de relleno
despues del salto inicial deja todas las words en direcciones pares
(0104h a 010Eh). El estado vale 0 para menu, 1 partida, 2 victoria,
3 derrota y 4 pausa. `mapa_original` y `mapa` tienen 300 bytes cada uno
(20 columnas por 15 filas). Los simbolos son # pared, espacio pasillo,
C moneda, X trampa y S salida. El jugador se dibuja encima del mapa sin
modificar su contenido.

El COM comparte segmento para codigo y datos y usa la pila del entorno DOS.
La interfaz escribe en B800h en modo texto 03h. Durante la partida, INT 16h
funcion 01h consulta el teclado sin bloquear y INT 1Ah funcion 00h lee los
ticks del BIOS (18.2 por segundo) para el cronometro y la duracion de los
sonidos. DOS INT 21h devuelve el control al sistema al salir.

## Pruebas

Las pruebas se realizan con el ejecutable en DOSBox-X, observando el
marcador y los estados. El informe tecnico contiene la bitacora de pruebas
y las capturas de cada caso.
