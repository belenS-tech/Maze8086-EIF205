# Bitacora de integracion - 29 de octubre de 2026

Entorno: Windows, EMU8086 4.08 para compilar, DOSBox-X 2026.10.01 para ejecutar.
Binario integrado: MAZE.COM, 2720 bytes. Resultado del arnes: **70/70 PASS**.

El arnes `preparar_pruebas.py` genera un TEST.COM que incluye los bytes reales
de MAZE.COM y llama a sus rutinas mediante la tabla de simbolos del compilador.
Para comprobar el bucle de estados, inyecta teclas mediante BIOS INT 16h/05h
y redirige solo el punto de salida del binario de prueba. El juego entregado
MAZE.COM no contiene esas modificaciones ni teclas de prueba.

| Caso | Resultado observado |
| --- | --- |
| Partida nueva | 3 vidas, 5 monedas, puntos y movimientos en cero |
| WASD, mayusculas y flechas | Avance de una celda y coordenadas correctas |
| Paredes | No permiten avanzar, no restan vidas |
| Cuatro limites | No hay coordenadas negativas ni indices fuera del mapa |
| Tecla no asignada | No mueve al jugador |
| Moneda | Suma 10, disminuye monedas y se consume |
| Volver a una moneda recogida | No vuelve a sumar puntos |
| Trampa | Resta una vida, devuelve a (1,1) y se consume |
| Tres trampas | Cero vidas y estado derrota; no hay desbordamiento posterior |
| Salida antes de recoger todo | Permanece bloqueada |
| Recorrido completo real | Cinco monedas, salida, 100 puntos y 3 vidas |
| Victoria repetida | No vuelve a sumar el bonus |
| Reinicio | Restaura los 300 bytes del mapa, las vidas y contadores |
| Record | Se conserva al reiniciar y volver al menu |
| Dibujo en memoria de video | Jugador, pared, moneda, trampa y salida con colores correctos |
| Pantallas finales y pausa | Se comprueba su contenido en B800h |
| Bucle real de teclado | Menu -> partida -> pausa -> Enter -> partida -> menu -> salida |
| R despues de ganar o perder | Reinicia con 3 vidas, cero puntos y el mismo record |
| Pila | SP termina con el valor inicial tras todas las llamadas |

Revision visual adicional en DOSBox-X: menu principal, tablero completo y
marcador, movimiento con flecha derecha, pausa con P y continuacion con Enter.
Las pantallas de victoria/derrota y sus controles se comprobaron con el arnes;
no se realizo una partida manual completa durante esta revision.

## Problemas detectados y soluciones

| Problema | Impacto | Solucion |
| --- | --- | --- |
| Ramas con modulos separados y main sin bucle | El programa terminaba sin ejecutar el juego | Archivo principal con llamadas y estados compartidos |
| Nombres distintos entre UI y reglas | La interfaz no podia leer las vidas/puntos reales | Unificar jugador_x/y, vidas, puntos, record_max y movimientos |
| Simbolos diferentes para moneda/salida | Los objetos no coincidian con las colisiones | Usar C, S y X en mapa y renderizado |
| Variables y mapa original sin declarar | Modulos incompletos al compilar juntos | Declarar dimensiones, contadores y copia original |
| INCLUDE de EMU8086 requiere macros y CRLF | Rutinas no reconocidas | Encapsular cada modulo en DEFINE_* con formato CRLF |
| Ruta con tilde en configuracion UTF-8 de DOSBox | Fallo al montar la carpeta | Lanzador con directorio build y montaje relativo |

Limitacion conocida: el record vive en memoria y se pierde al cerrar el
programa. No se implemento persistencia en un archivo.
