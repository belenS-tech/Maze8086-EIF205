# Maze8086 - Interfaz del integrante 1

Esta entrega es una **vista previa de la interfaz**, no el juego completo.
No implementa movimiento, colisiones, vidas, puntuacion ni reinicio de partida.
`movimiento.inc` y `juego.inc` permanecen vacios para los integrantes 2 y 3.

## Archivos

- `maze.asm`: datos de muestra y navegacion de la vista previa.
- `interfaz.inc`: menu, colores, tablero, jugador, marcador, pausa y pantallas finales.

## Compilar y revisar

1. Abrir `maze.asm` en EMU8086 con `interfaz.inc` en la misma carpeta.
2. Compilar como programa COM y guardar el resultado como `MAZE.COM`.
3. Para la vista previa: 1 abre el tablero; V muestra victoria; G muestra derrota;
   P muestra pausa; M vuelve al menu; ESC sale. En las pantallas finales o pausa,
   cualquier tecla vuelve al tablero. Flechas y WASD son textos de la interfaz
   prevista: no mueven al jugador en esta entrega.

EMU8086 necesita que los archivos INC con macros tengan saltos de linea CRLF.
`DEFINE_INTERFACE` debe invocarse una sola vez, despues del INCLUDE y despues
de un salto que evite ejecutar los datos/rutinas al arrancar.

## DOSBox

Compilar en EMU8086 y ejecutar el COM generado en DOSBox son pasos separados.
Copiar `MAZE.COM` a una carpeta sencilla, por ejemplo `C:\MAZE`, y ejecutar
dentro de DOSBox:

```text
mount c C:\MAZE
c:
MAZE.COM
```

La interfaz usa modo texto 03h, BIOS INT 10h/16h, memoria B800h y salida DOS
INT 21h. No necesita dispositivos virtuales exclusivos de EMU8086.
Se genero `build/MAZE.COM` con EMU8086 4.08: ensamblado correcto en tres pasadas,
1826 bytes. La ejecucion quedo pendiente: EMU8086 mostro que su periodo de
evaluacion habia vencido y no se localizo DOSBox en las ubicaciones revisadas.
No se ha validado visualmente la interfaz en ejecucion.

## Contrato para conectar los otros modulos

DS debe apuntar al segmento del COM. Coordenadas desde cero:

| Dato | Tipo | Significado |
| --- | --- | --- |
| `player_x`, `player_y` | byte | Columna 0..19, fila 0..14 |
| `lives` | byte | Vidas actuales |
| `score`, `high_score`, `moves` | word sin signo | Valores 0..65535 |
| `mapa` | 300 bytes | 20 columnas por 15 filas, contiguas |

Mapa: `#` pared, espacio pasillo, `.` objeto, `E` salida. El jugador se dibuja
encima, no se escribe dentro del mapa. El mapa de muestra es original y puede
ser reemplazado por el integrante 2 respetando dimensiones y simbolos.

Rutinas publicas sin parametros: `ui_init`, `ui_menu`, `ui_board`, `ui_hud`,
`ui_pause`, `ui_win`, `ui_lose`, `ui_shutdown`. Preservan registros; flags no.
`ui_board` redibuja tambien el marcador. Las rutinas de presentacion no esperan
teclas, no eligen estados y no modifican las variables del juego.

Al integrar el juego, reemplazar el bloque `inicio` y sus etiquetas `preview_*`
por el bucle real. Los textos `ui_demo` y `ui_preview_back` deben sustituirse
por los controles reales del juego integrado. El record en memoria puede
conservarse entre partidas; guardarlo entre ejecuciones requiere un archivo.

## Referencia revisada

Repositorio indicado por el grupo:
https://github.com/ramaadarsh/MICROPROCESOR-EMU8086-ASSEMBLY-LANGUAGE

Su archivo `FINALMAZE.asm` fue revisado como referencia. Esta interfaz se escribio
para la estructura modular local; no es un parche directamente aplicable a sus
variables ni una copia de su implementacion.

## Pendiente para completar el proyecto

Integrar movimiento y reglas de juego, verificar ejecucion en DOSBox, registrar
pruebas reales de estados y colisiones y elaborar el informe tecnico del grupo.
