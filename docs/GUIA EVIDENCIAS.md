# Cómo reproducir las pruebas de Maze8086

Esta guía indica las teclas exactas para repetir cada caso de la bitácora
(`tests/BITACORA.md`) y obtener las mismas capturas que están en la carpeta
`evidencias`. No hace falta modificar el código, las vidas ni el mapa.

Notación: `D×4` significa pulsar la tecla D cuatro veces. W, A, S y D
pueden reemplazarse por las flechas.

## Preparación

1. Abrir `maze.asm` en EMU8086 con `interfaz.inc`, `movimiento.inc`,
   `juego.inc` y `sonido.inc` en la misma carpeta.
2. Presionar **compile**, guardar como `build/MAZE.COM` y esperar el mensaje
   "assembled successfully" (E20).
3. Abrir `build/MAZE.COM.symbol` para revisar las direcciones (E21).
4. Ejecutar el juego en DOSBox de alguna de estas formas:
   - DOSBox-X: doble clic en `JUGAR.bat`.
   - DOSBox: arrastrar `build/MAZE.COM` sobre el ícono del programa.
   - DOSBox, con comandos:
     ```
     mount c "ruta\completa\de\la\carpeta\build"
     c:
     MAZE.COM
     ```

## Cómo capturar

- **DOSBox:** Ctrl+F5 guarda la pantalla del juego como PNG en la carpeta
  `capture` de DOSBox (en Windows, `%LOCALAPPDATA%\DOSBox\capture`).
- **EMU8086 y otras ventanas:** Win+Shift+S. Si DOSBox no deja usar el
  atajo, primero Ctrl+F10 para liberar el mouse.

## Emulador de EMU8086

1. Presionar **emulate** y luego **run**.
2. Antes de entrar a la partida, ajustar la ventana *emulator screen* hasta
   que el título diga **80x25 chars**. Con otro tamaño, el tablero se ve
   desplazado porque el juego escribe filas de 80 caracteres.
3. El emulador es lento: esperar a que el menú termine de dibujarse (E22),
   pulsar 1 y esperar el tablero (E23).

## Colisiones, monedas y trampas

Desde una partida nueva (pulsar 1 en el menú):

| Paso | Teclas | Resultado esperado | Figura |
| --- | --- | --- | --- |
| 1 | — | 3 vidas, 5 monedas, 0 puntos, 0 movimientos, tiempo 0 | E03, E24 |
| 2 | W | El jugador no se mueve: pared | E04 |
| 3 | D×3 | Recoge la primera moneda: 10 puntos y 4 monedas | E05 |
| 4 | A, D | Vuelve a la celda vacía: los puntos siguen en 10 | E06 |
| 5 | P | Pantalla de pausa | E07, E26 |
| 6 | D, Enter | D no mueve al jugador en pausa; Enter continúa | E08, E27 |
| 7 | Q, 1 | Nueva partida con 0 puntos y récord 10 | E09 |
| 8 | S×2, D×2 | Primera trampa: 2 vidas y regreso al inicio | E10 |
| 9 | S×2, D×2 | La trampa ya no está: las vidas siguen en 2 | E11 |

## Cronómetro y pausa

1. Pulsar 1 y capturar el tablero con el tiempo en 0 (E24).
2. Jugar o esperar unos 15 segundos y capturar: el tiempo avanza aunque no
   se pulsen teclas (E25).
3. Pulsar P y capturar la pantalla de pausa con el tiempo (E26).
4. Esperar unos 10 segundos, pulsar Enter y capturar: el tiempo es el mismo
   que en la pausa o un segundo más (E27).

## Salida cerrada

Desde una partida nueva:

> D×4 · S×2 · D×3 · S×2 · A×7 · S×8 · D×9 · W×2 · D×4 · S×2 · D×3

El jugador recoge 3 monedas y queda al lado de la salida. Al pulsar **D**
una vez más no entra, suena un tono grave y la partida sigue (E12).

## Victoria con bono

Desde una partida nueva, sin pasar por trampas:

> D×4 · S×2 · D×3 · S×2 · A×4 · D×4 · W×4 · D×5 · S×6 · D×5 · S×2 · A×10 · S×4 · A×4 · D×6 · W×2 · D×4 · S×2 · D×4

La pantalla de victoria muestra 100 puntos más el bono (120 menos los
segundos usados). En la figura E28 la partida duró 29 segundos: 100 + 91 =
191 puntos. Pulsar R restaura la partida y conserva el récord (E14).

## Derrota

Desde una partida nueva, cada trampa devuelve al jugador al inicio:

| Trampa | Posición (x, y) | Teclas desde el inicio | Vidas después |
| --- | --- | --- | --- |
| 1 | (3, 3) | S×2 · D×2 | 2 |
| 2 | (8, 7) | D×4 · S×2 · D×3 · S×4 | 1 |
| 3 | (17, 11) | D×4 · S×2 · D×3 · W×2 · D×5 · S×6 · D×5 · S×2 · A×2 · S×2 · D | 0, Game Over |

Capturar la pantalla de derrota (E15) y pulsar R para reiniciar sin cerrar
el emulador (E16).

## Bordes

Recorrer los pasillos junto a cada borde e intentar salir del mapa. El
jugador debe permanecer dentro del laberinto (E17).
