# Guion para explicar Maze8086

## Presentación de uno a dos minutos

«Desarrollamos un laberinto en ensamblador 8086. Compilamos con EMU8086 y
ejecutamos el archivo COM en DOSBox. El jugador recoge cinco monedas y llega
a la salida. Tiene tres vidas; las trampas quitan una vida y lo devuelven al
inicio. Dividimos el proyecto en interfaz, movimiento y reglas de juego».

Muestren primero el menú, después una moneda, una pared y la pausa. Abran
el código solo después de que el público conozca qué hace el juego.

## Integrante 1 y la interfaz

Abre `interfaz.inc` y explica `ui_init`, `ui_offset`, `ui_fill`, `ui_text`,
`ui_box`, `ui_board` y `ui_hud`, en ese orden.

«Elegimos modo texto 80 por 25, permitido por el enunciado. Cada carácter
tiene un byte para su símbolo y otro para el color. La pantalla empieza en
el segmento B800h. La posición se calcula como fila por 160 más columna por
dos. Por ejemplo, fila 7 y columna 13 corresponden al desplazamiento 1146.
No se debe confundir esa posición de pantalla con el índice del mapa».

`ui_board` interpreta #, C, X y S. Cada celda del mapa ocupa dos columnas de
pantalla; @ se dibuja encima y no se guarda dentro del mapa. Esto evita perder
la información de una moneda o una salida al mover al jugador. `ui_box` usa
caracteres CP437 de doble línea. `ui_number` divide el número entre diez para
formar sus cinco dígitos decimales. La macro UI_LABEL prepara posición, texto
y color; CALL ui_text ejecuta una sola rutina compartida.

## Integrante 2 y el movimiento

Abre `procesar_movimiento` y `verificar_destino` en `movimiento.inc`.
«INT 16h entrega la letra en AL y el código de tecla en AH. Copiamos la
posición actual a BL y BH, calculamos una posición candidata y comprobamos
sus límites antes de leer el mapa. Si hay pared, no actualizamos la posición».

El índice es y por ANCHO más x. Ejemplo: (4,1) es 1 por 20 más 4, índice 24.
`MUL CL` multiplica AL por CL y deja el resultado en AX; después se usa SI
para acceder a `mapa[si]`. `XOR BH,BH` elimina el byte alto de BX antes de
sumar la columna. `DIV CL` recupera fila en AL y columna en AH al dividir el
índice por el ancho. Una C llama a `sumar_moneda`; una X a `perder_vida`;
S solo se acepta cuando `monedas` vale cero.

## Integrante 3 y las reglas

Abre `juego.inc`. «reiniciar_juego copia 300 bytes del mapa original al mapa
activo con REP MOVSB. DS:SI es el origen y ES:DI el destino. CLD hace que los
punteros avancen. Reponemos vidas y monedas, pero no borramos record_max».

`sumar_moneda` suma diez y reduce las pendientes. El módulo de movimiento
borra la C después, por eso no se cobra dos veces. `perder_vida` reduce vidas;
si quedan, vuelve al inicio; si se agotan, pone estado 3. `ganar_partida` suma
50 solo en estado de partida y con cero monedas. `actualizar_record` usa JBE,
comparación sin signo, para guardar el mayor puntaje.

## Archivo principal y estados

Abre `maze.asm`: ORG 100h, salto inicial, datos, includes e `inicio`.
«ORG 100h corresponde al punto de carga de un COM después del PSP de DOS.
El JMP evita ejecutar los datos. PUSH CS y POP DS hacen que DS apunte al
segmento del programa. El estado controla qué pantalla se dibuja y qué teclas
son válidas: 0 menú, 1 partida, 2 victoria, 3 derrota y 4 pausa».

INT 10h selecciona video y cursor; INT 16h espera una tecla; INT 21h/4Ch sale
a DOS. La partida no avanza sin entrada y no necesita física continua ni
retardos artificiales. Reiniciar es una transición del programa, no reiniciar
DOSBox. CALL apila la dirección de retorno y RET la recupera; los PUSH/POP
de las rutinas preservan sus registros en orden inverso.

## Preguntas que deben poder responder

- ¿Por qué DB y DW? Posiciones y vidas caben en un byte; puntaje y movimientos usan 16 bits.
- ¿Qué diferencia hay entre mapa y mapa_original? El primero cambia; el segundo restaura la partida.
- ¿Se guarda el récord al cerrar? No; vive en memoria durante la ejecución.
- ¿Por qué el puntaje final siempre es 100? Cinco monedas por diez y cincuenta por salir; se compara también el número de movimientos.
- ¿Qué se mejoró visualmente? Título ASCII, marcos, textura y colores, sin cambiar el modelo de colisiones.
- ¿Para qué sirve Git? Para integrar aportes y mostrar un historial real; no basta con subir un único archivo final.
- ¿Por qué aparecen referencias MIPS en el enunciado? El proyecto usa SP, registros e instrucciones 8086; no existen $ra ni $s0 en esta arquitectura.

Eviten memorizar todo palabra por palabra. Cada integrante debe explicar una
rutina con un ejemplo y mostrar dónde se llama. Lean la bitácora y reproduzcan
las pruebas antes de afirmar que las realizaron.
