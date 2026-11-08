# Bitácora de pruebas

Pruebas manuales hechas con el teclado, observando el marcador y las
pantallas. Las capturas están en la carpeta `evidencias` y en la sección 5
del informe técnico (`docs/Informe Tecnico.pdf`). Las teclas para
reproducir cada caso están en `docs/GUIA EVIDENCIAS.md`.

Hubo dos rondas de pruebas:

| Ronda | Versión | Ejecutable | Entorno | Figuras |
| --- | --- | --- | --- | --- |
| 1 | Anterior, sin cronómetro ni sonido | MAZE.COM de 3376 bytes | DOSBox-X 2026.10.01 | E01 a E17 |
| 2 | Final | MAZE.COM de 3865 bytes | Emulador de EMU8086 4.08 y DOSBox 0.74-3 | E20 a E28 |

La versión final no cambió las reglas de movimiento, monedas, trampas ni
estados, por lo que las pruebas de la ronda 1 siguen siendo válidas.

## Ronda 1: colisiones y límites

| Fig. | Acción | Esperado | Observado | Resultado |
| --- | --- | --- | --- | --- |
| E04 | Desde el inicio, pulsar W contra la pared | El jugador no se mueve | Misma posición que en E03 y 0 movimientos | Aprobado |
| E05 | Pulsar D tres veces desde el inicio | Recoger la primera moneda y sumar 10 | 10 puntos, 4 monedas pendientes y 3 movimientos | Aprobado |
| E06 | Salir de la celda de la moneda y volver con A y D | No volver a sumar puntos | 10 puntos, 4 monedas pendientes y 5 movimientos | Aprobado |
| E10 | Desde el inicio, pulsar S, S, D, D | Perder una vida y volver al inicio | 2 vidas, jugador en el inicio y la trampa ya no aparece | Aprobado |
| E11 | Repetir S, S, D, D | Pasar por la celda sin perder otra vida | El jugador llega a la celda y conserva 2 vidas | Aprobado |
| E12 | Intentar entrar a S con monedas pendientes | Seguir en partida sin bonificación | Jugador junto a la salida, 30 puntos y 2 monedas pendientes antes y después | Aprobado |
| E17 | Intentar avanzar hacia el borde del laberinto | El jugador permanece dentro del mapa | El jugador queda dentro del laberinto, junto al borde | Aprobado |

## Ronda 1: estados

| Fig. | Acción | Esperado | Observado | Resultado |
| --- | --- | --- | --- | --- |
| E01 | Compilar la versión anterior en EMU8086 | Generar el COM sin errores | Cuatro pasadas; MAZE.COM de 3376 bytes | Aprobado |
| E02 | Ejecutar MAZE.COM | Ver el menú principal | Menú con las opciones 1 y ESC | Aprobado |
| E03 | Pulsar 1 en el menú | Iniciar con los valores base | 3 vidas, 5 monedas, 0 puntos y 0 movimientos | Aprobado |
| E07, E08 | Pulsar P, intentar mover y reanudar con Enter | Pausar y continuar sin cambios | Pantalla de pausa; al reanudar, misma celda con 10 puntos y 5 movimientos | Aprobado |
| E09 | Volver al menú e iniciar otra partida después de puntuar | Reiniciar el puntaje y conservar el récord | 0 puntos, récord 10, 3 vidas y 5 monedas | Aprobado |
| E13 | Recoger las cinco monedas y entrar en S | Ganar con 100 puntos | Victoria con 100 puntos y récord 100 | Aprobado |
| E14 | Pulsar R en la pantalla de victoria | Restaurar la partida y conservar el récord | 3 vidas, 5 monedas, 0 puntos, 0 movimientos y récord 100 | Aprobado |
| E15 | Activar las tres trampas | Pasar al estado de derrota | Game Over con récord 100 | Aprobado |
| E16 | Pulsar R en la pantalla de derrota | Reiniciar sin cerrar el emulador | Tablero inicial, 3 vidas, 5 monedas y récord 100 | Aprobado |

## Ronda 2: versión final

| Fig. | Acción | Esperado | Observado | Resultado |
| --- | --- | --- | --- | --- |
| E20 | Compilar maze.asm con los cuatro INC en EMU8086 | Generar el COM sin errores | Cuatro pasadas; MAZE.COM de 3865 bytes | Aprobado |
| E21 | Abrir MAZE.COM.symbol | Variables word en direcciones pares | puntos 0104h, record_max 0106h, movimientos 0108h, segundos 010Ah, ticks_partida 010Ch, tick_anterior 010Eh | Aprobado |
| E22 | Ejecutar el programa en el emulador de EMU8086 | Ver el menú completo | Menú con las opciones y la línea del bono | Aprobado |
| E23 | Pulsar 1 en el emulador de EMU8086, con la ventana en 80 × 25 | Ver el tablero y el marcador | Tablero completo con TIEMPO (SEG) en 0 | Aprobado |
| E24 | En DOSBox, pulsar 1 en el menú | Iniciar con el reloj en cero | 3 vidas, 5 monedas, 0 puntos, 0 movimientos y tiempo 0 | Aprobado |
| E25 | Jugar unos segundos y recoger tres monedas | El reloj avanza durante la partida | Tiempo 15, 30 puntos, 2 monedas y 40 movimientos | Aprobado |
| E26 | Pulsar P y esperar en la pausa | Pausa con el tiempo detenido | Pantalla de pausa con 30 puntos y tiempo 17 | Aprobado |
| E27 | Pulsar Enter para continuar | No sumar el tiempo en pausa | Misma posición y marcador; tiempo 18, un segundo más que al pausar | Aprobado |
| E28 | Recoger las cinco monedas y entrar en S | 100 puntos más el bono (120 − segundos) | Victoria en 29 s con 191 puntos (100 + 91) y récord 191 | Aprobado |
| — | Intentar entrar a S con 2 monedas pendientes | El jugador no se mueve y suena un tono grave | Se escucha el tono y la partida sigue | Aprobado |
| — | Recoger una moneda, tocar una trampa, ganar y perder | Un sonido distinto en cada evento | Se escuchan los sonidos en DOSBox | Aprobado |

El sonido no se puede mostrar en una captura. En el emulador de EMU8086 es
posible que el parlante no se reproduzca; el juego funciona igual.

## Errores encontrados y soluciones

| Error | Impacto | Solución aplicada |
| --- | --- | --- |
| Nombres de variables distintos entre módulos | La interfaz y las reglas no compartían posición, vidas, puntos ni récord | Unificar los nombres de las variables compartidas en maze.asm |
| Símbolos de celda inconsistentes | El mapa dibujado no coincidía con lo que revisaban las colisiones | Usar # pared, C moneda, X trampa y S salida en todos los módulos |
| Ciclo de juego incompleto | El programa terminaba antes de procesar una partida | Conectar el menú, la espera de teclado y las transiciones de estado |
| Rutinas incluidas no reconocidas por EMU8086 | El ensamblador no encontraba algunos procedimientos de los INC | Agrupar cada módulo en una macro DEFINE_ y guardar los INC con CRLF |
| Ruta con tildes al montar la carpeta | DOSBox-X no encontraba la carpeta del juego | Montar build con una ruta relativa desde play.conf y abrirlo con JUGAR.bat |
| Desalineación de memoria: puntos, record_max y movimientos en 0107h, 0109h y 010Bh | Cada acceso a esas variables necesitaba dos ciclos de bus en un 8086 | Byte de relleno después del salto inicial y variables word declaradas primero |
| Tablero desplazado en el emulador de EMU8086 | Con la ventana en 86 × 30 o 110 × 36, cada fila aparecía corrida | El juego escribe filas de 80 caracteres en B800h; se ajusta la ventana a 80 × 25 |
| Reloj sin actualizarse mientras se espera una tecla | INT 16h/00h detiene el programa y el tiempo no cambiaba en pantalla | Consultar el teclado con INT 16h/01h y actualizar el reloj mientras no hay tecla |

## Limitaciones conocidas

- El récord se guarda solo en memoria y se pierde al cerrar el programa.
- Hay un solo nivel. Una victoria vale entre 100 y 220 puntos.
