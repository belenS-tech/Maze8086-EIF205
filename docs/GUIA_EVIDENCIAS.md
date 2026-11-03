# Cómo tomar las evidencias en EMU8086 y DOSBox

Usen la misma compilación para todas las capturas. No modifiquen las vidas,
el mapa ni los puntos para simular resultados. Cada captura debe mostrar la
ventana del programa, el marcador y el estado que se quiere demostrar.

## Preparación

1. Abran `maze.asm` en EMU8086. Los tres INC deben estar en la misma carpeta.
2. Compilen y guarden en `build/MAZE.COM`. Fotografíen o capturen el mensaje
   de compilación correcta como `E01_compilacion.png`.
3. Ejecuten `JUGAR.bat` y capturen el menú como `E02_menu.png`.
4. Presionen 1. Capturen `E03_inicio.png`: 3 vidas, 5 monedas y 0 puntos.
5. Para capturar sin instalar nada, presionen Alt+Impr Pant, peguen en Paint
   y guarden como PNG en `evidencias`. También pueden usar Recortes con ratón.
   La captura puede no abrirse automáticamente: comprueben el archivo guardado.

## Secuencia corta para las primeras pruebas

Desde una partida nueva, cada letra representa una pulsación WASD.

| Paso | Acción | Resultado que se debe ver | Archivo |
| --- | --- | --- | --- |
| 1 | W desde el inicio | No avanza contra la pared; puntos y vidas iguales | E04_pared.png y comparación con E03 |
| 2 | D D D | Recoge la primera C: 10 puntos, 4 monedas, 3 movimientos | E05_moneda.png |
| 3 | A D | Vuelve a la celda vacía: los puntos siguen en 10 | E06_no_repite.png |
| 4 | P | Pantalla de pausa | E07_pausa.png |
| 5 | D mientras está pausado y luego Enter | Continúa en la misma celda; D no movió al jugador durante la pausa | E08_continuar.png |
| 6 | Q, 1 | Nueva partida con cero puntos y récord 10 | E09_record.png |
| 7 | S S D D | Toca la primera X: queda con 2 vidas y vuelve al inicio | E10_trampa.png |
| 8 | S S D D | La trampa ya desapareció y las vidas siguen en 2 | E11_trampa_consumida.png |

## Victoria y derrota

Para victoria, recorran el mapa con las flechas o WASD, recojan las cinco C
y eviten X. Intenten entrar en S cuando aún quede alguna moneda y documenten
que no se permite la salida (`E12_salida_bloqueada.png`). Antes de entrar en S
con todas las monedas, el panel debe indicar 50 puntos y cero monedas.
Después de entrar en S debe mostrarse victoria con 100 puntos
(`E13_victoria.png`). Presionen R y capturen el tablero restaurado con 3 vidas,
5 monedas, cero puntos y récord 100 (`E14_reinicio.png`).

Para derrota, inicien una partida y toquen las tres X diferentes. Cada trampa
desaparece al tocarla; volver a esa misma celda no resta otra vida. Las trampas
están en (3,3), (8,7) y (17,11), con coordenadas del mapa desde cero, no de la
pantalla. Documenten vidas 2, 1 y luego derrota (`E15_derrota.png`). Presionen
R para demostrar que no es necesario cerrar DOSBox (`E16_reinicio_derrota.png`).

## Límites y registros

Recorran los pasillos junto a cada borde e intenten cruzar las paredes. El
jugador no debe salir del mapa. En EMU8086, si disponen de ejecución habilitada,
pueden inspeccionar SP antes y después de una llamada con Single Step; debe
regresar al mismo valor. Esa inspección es adicional y no debe presentarse
como realizada si la licencia impide ejecutarla.

## Cómo escribir cada resultado

En la bitácora, registren ID, fecha, integrante, pasos, resultado esperado,
resultado observado, aprobado o fallido y nombre del PNG. Una captura del
tablero aislada no demuestra por sí sola una colisión: acompañen el antes y
el después o una grabación corta. No pongan «aprobado» en casos no ejecutados.

Inserten las imágenes como figuras del informe con una explicación: «Figura
E10. Después de tocar X, el contador baja de tres a dos vidas y el jugador
regresa a la posición inicial». Completen nombres del grupo y profesor antes
de entregar. No se requiere Python ni otro ensamblador para estas pruebas.
