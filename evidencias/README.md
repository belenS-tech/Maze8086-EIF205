# Evidencias

Capturas de las pruebas de Maze8086. Cada archivo corresponde a una figura
del informe técnico (`docs/Informe Tecnico.pdf`) y a una fila de la
bitácora (`tests/BITACORA.md`). Las teclas para repetir cada caso están en
`docs/GUIA EVIDENCIAS.md`.

## Versión anterior (DOSBox-X, MAZE.COM de 3376 bytes)

El marcador de estas capturas no tiene la línea del tiempo. Las reglas que
muestran no cambiaron en la versión final.

| Archivo | Qué muestra |
| --- | --- |
| E01_compilacion_version_anterior | Compilación en EMU8086, 3376 bytes |
| E02_menu | Menú principal |
| E03_inicio | Inicio de partida: 3 vidas, 5 monedas, 0 puntos |
| E04_pared | Movimiento bloqueado por una pared |
| E05_moneda | Primera moneda: 10 puntos, 4 monedas |
| E06_moneda_no_repite | La moneda recogida no vuelve a sumar |
| E07_pausa | Pantalla de pausa |
| E08_continuar | Partida reanudada sin cambios |
| E09_record_conservado | Nueva partida con récord 10 |
| E10_trampa | Trampa: 2 vidas y regreso al inicio |
| E11_trampa_consumida | La trampa activada ya no quita vidas |
| E12a, E12b | Salida cerrada con 2 monedas pendientes, antes y después |
| E13_victoria_version_anterior | Victoria con 100 puntos |
| E14_reinicio_victoria | Reinicio con récord conservado |
| E15_derrota | Game Over tras las tres trampas |
| E16_reinicio_derrota | Reinicio después de la derrota |
| E17_limites | El jugador permanece dentro del mapa |
| E18a, E18b | Maze8086 y el juego de referencia |
| E19_historial_git | Historial de commits por autor |

## Versión final (MAZE.COM de 3865 bytes)

| Archivo | Entorno | Qué muestra |
| --- | --- | --- |
| E20_compilacion_final | EMU8086 | Compilación sin errores, 3865 bytes |
| E21_tabla_simbolos | EMU8086 | Variables word en direcciones pares (0104h a 010Eh) |
| E22_menu_emu8086 | Emulador de EMU8086 | Menú con la línea del bono |
| E23_tablero_emu8086 | Emulador de EMU8086 | Tablero en 80 × 25 con el reloj |
| E24_inicio_cronometro | DOSBox | Inicio con el tiempo en 0 |
| E25_reloj_avanzando | DOSBox | Tiempo en 15 segundos |
| E26_pausa_tiempo | DOSBox | Pausa con el tiempo en 17 |
| E27_reanudar | DOSBox | Partida reanudada, tiempo 18 |
| E28_victoria_bono | DOSBox | Victoria en 29 s: 191 puntos (100 + 91 de bono) |
