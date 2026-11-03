# Informe técnico de Maze8086

Universidad Nacional

Escuela de Informática

Arquitectura de Computadoras EIF205

Proyecto 2 Juego de laberinto en ensamblador 8086

Integrantes: completar nombres y carnés de los tres integrantes

Profesor: completar nombre

Fecha: 2 de noviembre de 2026

## Introducción

Maze8086 es un juego bidimensional de laberinto desarrollado en ensamblador
8086. El jugador controla un símbolo dentro de un mapa, recoge monedas y
busca la salida mientras evita trampas. El objetivo académico es aplicar
direccionamiento de memoria, registros, procedimientos, macros, pila e
interrupciones en un programa interactivo. El proyecto se compila con
EMU8086 y se ejecuta como un programa COM de DOS dentro de DOSBox-X.

La implementación utiliza modo texto de 80 columnas y 25 filas. Esta decisión
permite representar paredes, jugador y objetos mediante caracteres y colores,
manteniendo una lógica de colisiones basada en una matriz. La interfaz
incluye menú, instrucciones, marcador, pausa y pantallas finales. El programa
distingue explícitamente victoria y derrota y permite reiniciar sin cerrar
DOSBox. La presentación visual no interviene en la decisión de si una celda
es transitable; esa información se conserva en el mapa en memoria.

El documento describe la arquitectura, el almacenamiento, los módulos y la
metodología de pruebas manuales. Las capturas se incorporan como evidencias
identificadas por caso; los campos de resultado deben completarse únicamente
después de reproducir cada escenario sobre la compilación entregada.

## Objetivos y alcance

El objetivo general es implementar un juego sencillo que permita comprender
el funcionamiento de un programa 8086 y su interacción con video y teclado.
Los objetivos específicos son organizar el código en módulos, comprobar
límites antes de acceder a memoria, preservar registros en las rutinas y
gestionar las transiciones de estado sin reiniciar el entorno de ejecución.

La partida dispone de cinco monedas y tres vidas. Cada moneda otorga diez
puntos y la salida concede cincuenta adicionales cuando ya no quedan monedas.
Las paredes bloquean el movimiento sin restar vidas. Cada trampa consume una
vida y desaparece; si aún quedan vidas, el jugador regresa a la posición
inicial. La tercera trampa produce derrota. La victoria tiene una puntuación
total de cien, y el contador de movimientos permite observar la longitud del
recorrido. El récord conserva el mayor puntaje durante la ejecución.

El alcance comprende un nivel fijo, entrada por teclado y modo texto. No se
incluyen enemigos, sonido, desplazamiento automático ni física continua.
El juego avanza por pulsaciones: no requiere un reloj de simulación ni bucles
de espera artificiales. El récord no persiste en disco al cerrar el programa.

## Arquitectura del software

El archivo principal maze.asm contiene las dimensiones, los datos compartidos,
el mapa inicial y el ciclo de estados. interfaz.inc reúne las rutinas de
presentación; movimiento.inc interpreta el teclado y comprueba el destino;
juego.inc actualiza vidas, puntuación, récord y condiciones finales. Esta
separación permite cambiar colores y marcos sin modificar las colisiones,
o revisar una regla sin duplicar el código que dibuja el tablero.

La ejecución comienza con ORG 100h y un salto a inicio. El salto evita que el
procesador interprete las variables o los procedimientos incluidos como
instrucciones de arranque. PUSH CS y POP DS establecen el segmento de datos
del programa. CLD deja el sentido de las operaciones de cadena hacia
direcciones crecientes. La rutina ui_init configura el video; a continuación,
el programa muestra el menú y espera entrada mediante INT 16h.

El flujo general es teclado, movimiento candidato, validación, actualización
de reglas, consulta del estado y renderizado. No existen llamadas recursivas
para reiniciar. El archivo principal salta al bloque nueva_partida, que llama
a reiniciar_juego y regresa al ciclo normal. Esto mantiene acotado el uso de
la pila y conserva una única instancia de los datos de la partida.

### Estados del programa

| Valor | Estado | Comportamiento |
| --- | --- | --- |
| 0 | Menú | 1 inicia una partida y Escape termina el programa |
| 1 | Partida | Movimiento, monedas, trampas y salida habilitados |
| 2 | Victoria | R reinicia, M o Q vuelven al menú, Escape sale |
| 3 | Derrota | Las mismas opciones finales sin permitir movimiento |
| 4 | Pausa | P o Enter continúan; Q o Escape vuelven al menú |

procesar_movimiento solo actúa cuando estado vale uno. Las pantallas
ui_win, ui_lose y ui_pause presentan el resultado; no alteran las reglas.
Los procedimientos de puntuación también comprueban el estado, de modo que
no se otorguen bonificaciones adicionales después de terminar una partida.

## Mapeo de memoria y datos

Un programa COM se carga después del PSP de DOS, por eso ORG 100h fija el
desplazamiento de referencia. El código y los datos se organizan en un mismo
segmento. Las variables se acceden con DS; la copia del mapa usa ES:DI como
destino. La pila pertenece al entorno DOS y se utiliza mediante SS:SP.
La dirección física en modo real se obtiene como segmento por dieciséis
más desplazamiento; un desplazamiento no constituye por sí solo una dirección
física completa.

| Elemento | Reserva | Función |
| --- | --- | --- |
| jugador_x y jugador_y | Un byte cada uno | Columna y fila entre 0..19 y 0..14 |
| vidas y monedas | Un byte cada uno | Vidas disponibles y monedas pendientes |
| estado | Un byte | Estado actual del programa |
| puntos y record_max | Una palabra cada uno | Puntaje actual y mejor puntaje de la sesión |
| movimientos | Una palabra | Número de desplazamientos aceptados |
| mapa_original | 300 bytes | Distribución inicial que no se modifica |
| mapa | 300 bytes | Copia activa en la que se consumen objetos |
| ui_number_buffer | Seis bytes | Cinco cifras decimales y terminador cero |

Las posiciones se miden desde cero. El mapa tiene veinte columnas y quince
filas almacenadas contiguamente por filas. El índice de una celda es
índice = y * 20 + x. Por ejemplo, la posición (4,1) corresponde al byte 24
desde el comienzo del mapa. Los límites se comprueban antes de utilizar SI
como índice, evitando lecturas fuera de los trescientos bytes reservados.
Las constantes EQU no reservan memoria: representan valores usados durante
el ensamblado, como ANCHO, ALTO y TOTAL.

Los símbolos internos son # para pared, C para moneda, X para trampa y S para
salida. Un espacio representa un pasillo. El jugador no se escribe en esta
matriz: sus coordenadas se mantienen aparte y la interfaz lo superpone como
@. Así, el renderizado no destruye la celda que se encuentra debajo del jugador.

### Memoria de video

El modo texto en color utiliza el segmento B800h. Cada posición de pantalla
ocupa dos bytes: carácter y atributo. La pantalla de 80 por 25 utiliza 4000
bytes. El desplazamiento es fila * 160 + columna * 2; la multiplicación por
160 corresponde a ochenta caracteres de dos bytes cada uno. El atributo
determina color de primer plano y fondo.

ui_offset calcula este desplazamiento, ui_fill repite una palabra de carácter
y atributo, y ui_text recorre una cadena terminada en cero. El tablero empieza
en fila seis y columna cinco; cada celda lógica ocupa dos columnas de pantalla.
Los marcos usan caracteres de doble línea del juego CP437. Las paredes tienen
textura y fondo azul; las trampas y la salida usan fondos diferenciados. Estos
atributos son presentación y no sustituyen los símbolos lógicos del mapa.

## Descripción de módulos y rutinas

### Archivo principal

mostrar_menu dibuja las opciones e inicia la espera de una tecla. Una nueva
partida llama a reiniciar_juego. dibujar_partida llama a ui_board y después
INT 16h recibe otra tecla. Tras procesarla, se examina estado y se elige
continuar, mostrar pausa o presentar una pantalla final. Al salir se restaura
el modo de texto y se llama a INT 21h con AX igual a 4C00h para retornar a DOS.

### Interfaz

ui_init selecciona el modo de video 03h mediante INT 10h y oculta el cursor.
ui_clear limpia la pantalla y dibuja las bandas informativas. ui_box construye
marcos de doble línea a partir de dos esquinas y un atributo. ui_menu_art
compone el título ASCII y el marco del menú. ui_menu agrega instrucciones y
las opciones de inicio y salida. Las rutinas guardan los registros que usan
para que el dibujo no cambie el estado lógico del juego.

ui_board recorre los 300 símbolos del mapa y escoge su apariencia. Después
dibuja al jugador en las coordenadas compartidas y llama a ui_hud. El marcador
muestra puntos, récord, vidas, movimientos y monedas pendientes. ui_number
convierte un entero sin signo en cinco dígitos: divide sucesivamente entre
diez, transforma el residuo en ASCII sumando el carácter cero y llena el
buffer desde el final hacia el principio.

La macro UI_LABEL prepara fila, columna, texto y color antes de llamar a
ui_text. Una macro se expande durante el ensamblado; un procedimiento tiene
una dirección que se reutiliza con CALL y RET. DEFINE_INTERFACE,
DEFINE_MOVIMIENTO y DEFINE_JUEGO emiten los bloques de cada módulo al
invocarse una vez desde maze.asm, según el mecanismo de inclusión de EMU8086.

### Movimiento y colisiones

procesar_movimiento conserva AX, BX, CX, DX y SI. Lee la posición actual en
BL y BH y reconoce los códigos de las flechas entregados en AH por BIOS.
Para letras utiliza AL, admite mayúsculas y minúsculas, y reconoce WASD, P y
Q. Escape vuelve al menú. El desplazamiento se calcula primero sobre una
posición candidata, sin modificar aún las coordenadas compartidas.

verificar_destino compara la columna con ANCHO y la fila con ALTO usando
comparaciones sin signo. Al decrementar cero, el byte pasa a FFh y también
es rechazado por estas comparaciones. Después multiplica fila por ancho y
suma la columna. Una pared cancela la operación; un pasillo permite mover;
C y X desencadenan las reglas correspondientes. La salida permanece
bloqueada mientras monedas sea distinto de cero.

contar_movimiento aumenta el contador solo en desplazamientos aceptados,
incluidos los que entran en trampas o en la salida. El contador se satura en
65535 para no volver a cero por desbordamiento. En la partida actual los
puntos no pueden exceder cien, pues hay cinco objetos y una única victoria.

### Reglas del juego

reiniciar_juego preserva ES y los registros de copia, hace ES igual a DS y
usa REP MOVSB con CX igual a TOTAL para restaurar el mapa. Repone vidas,
monedas, coordenadas, puntos y movimientos y establece estado de partida.
No modifica record_max, de modo que una partida nueva conserva el récord.

sumar_moneda reduce las monedas pendientes y agrega diez puntos. El módulo
de movimiento convierte luego la celda C en un espacio; esto impide cobrarla
por segunda vez. perder_vida reduce el contador protegido contra cero. Si
quedan vidas devuelve al jugador al inicio; si no quedan, selecciona derrota.
La celda de trampa se consume después de la llamada, conservando SI.

ganar_partida requiere estado de partida y cero monedas; suma cincuenta,
actualiza el récord y establece victoria. actualizar_record compara puntos
y record_max mediante JBE, apropiado para valores sin signo, y guarda el
puntaje mayor. No se utilizan archivos de DOS para persistir el récord.

## Registros pila e interrupciones

AX participa en cálculos, conversión decimal y funciones de interrupción.
BX combina columna y fila candidatas; CX controla repeticiones o aporta el
ancho para operaciones de ocho bits. SI y DI recorren datos de origen y
destino. DS apunta al segmento del programa y ES se usa temporalmente para
copiar el mapa o escribir en video. Las rutinas restauran los registros que
preservan con POP en orden inverso a los PUSH.

CALL apila la dirección de retorno y RET la extrae. Esta organización permite
llamadas anidadas como procesar_movimiento, sumar_moneda y actualizar_record
sin perder el punto al que regresar. No se utiliza recursión ni memoria
dinámica. Los flags no forman parte del contrato de preservación de la UI.
El código 8086 usa SP; los nombres $sp, $ra y $s0 citados para MIPS en algunas
partes del enunciado no corresponden a registros de esta arquitectura.

| Interrupción | Uso en el proyecto |
| --- | --- |
| INT 10h con AX 0003h | Configurar modo texto 80 por 25 y restaurarlo al salir |
| INT 10h con AH 01h | Configurar el cursor y ocultarlo durante el juego |
| INT 16h con AH 00h | Esperar una tecla y obtener ASCII en AL y código en AH |
| INT 21h con AX 4C00h | Terminar el programa y devolver control a DOS |

## Compilación ejecución y control de versiones

Los cuatro archivos fuente deben permanecer juntos. Se abre maze.asm en
EMU8086, se compila y se guarda como build/MAZE.COM. El tamaño y la fecha del
binario deben corresponder a la revisión entregada. Para jugar se utiliza
JUGAR.bat, que abre DOSBox-X y monta la carpeta build con la configuración
play.conf. El montaje relativo evita problemas de codificación de tildes.

Los cambios se distribuyen en ramas de interfaz, movimiento y juego y se
integran en una versión común. El grupo debe verificar que la rama elegida
para entregar contiene los fuentes, README, COM actualizado e informe. Los
commits de los integrantes constituyen evidencia del trabajo distribuido;
la presentación debe relacionar cada aporte con sus rutinas concretas.

## Bitácora de pruebas manuales

El procedimiento de aceptación consiste en compilar con EMU8086 y reproducir
las acciones con teclado sobre MAZE.COM en DOSBox. Cada caso registra fecha,
responsable, pasos, esperado, observado y captura. La columna observado no
debe completarse por deducción a partir del código. Las evidencias se guardan
en la carpeta evidencias y se incorporan al informe con su identificador.

| Caso | Pasos resumidos | Resultado esperado |
| --- | --- | --- |
| P01 Inicio | Menú y tecla 1 | 3 vidas, 5 monedas y cero puntos |
| P02 Pared | W desde la posición inicial | Posición, vidas y movimientos sin cambio |
| P03 Moneda | D D D desde el inicio | 10 puntos y 4 monedas |
| P04 Moneda consumida | A D después de P03 | Continúan 10 puntos |
| P05 Pausa | P, D y Enter | Pausa visible y reanudación en la misma celda |
| P06 Trampa | Nueva partida y S S D D | 2 vidas y regreso al inicio |
| P07 Trampa consumida | Repetir el recorrido a la primera X | No pierde una segunda vida allí |
| P08 Salida bloqueada | Llegar a S con alguna C pendiente | Sigue en partida y no suma bonus |
| P09 Victoria | Recoger todas las C y entrar en S | Victoria y 100 puntos |
| P10 Derrota | Tocar las tres trampas distintas | Cero vidas y pantalla de derrota |
| P11 Reinicio | R desde cada pantalla final | Mapa restaurado y récord conservado |
| P12 Salida | Q durante partida, Escape en menú | Retorno al menú y luego a DOS |

Las capturas sugeridas son E01 para compilación, E02 para menú, E03 para
inicio y E04 a E16 para las acciones detalladas en GUIA_EVIDENCIAS.md.
La bitácora independiente tests/BITACORA.md contiene los resultados de la
revisión y permite agregar los del grupo. Las capturas de antes y después
son necesarias para demostrar que un choque o una pausa no cambió la partida.

### Errores encontrados y soluciones

| Situación | Efecto | Solución |
| --- | --- | --- |
| Nombres distintos entre módulos | UI y reglas no compartían los mismos datos | Unificar jugador_x, vidas, puntos y record_max |
| Monedas y salida con símbolos diferentes | El mapa visible no coincidía con la lógica | Usar C, X y S en ambos módulos |
| Archivo principal sin ciclo de juego | El programa terminaba inmediatamente | Integrar llamadas y transiciones de estado |
| Datos de partida sin declarar | No se podían enlazar las rutinas | Declarar dimensiones, contadores y mapa original |
| Inclusión de rutinas en EMU8086 | El ensamblador no reconocía procedimientos incluidos | Macros DEFINE y archivos INC con CRLF |
| Ruta de montaje con caracteres acentuados | DOSBox no encontraba la carpeta | Montaje relativo desde build mediante lanzador |

## Conclusiones

El proyecto relaciona instrucciones de bajo nivel con un comportamiento
interactivo completo. La matriz lógica simplifica las colisiones, mientras
que la memoria de video permite controlar la presentación sin alterar las
reglas. El diseño modular hace explícitas las responsabilidades y permite
que cada integrante explique y revise una parte identificable del programa.

La restauración del mapa desde una copia inmutable resuelve el reinicio sin
cerrar DOSBox. Los estados separan menú, partida, pausa y final y evitan
procesar movimientos cuando no corresponde. La preservación de registros
y el equilibrio entre CALL, RET, PUSH y POP son esenciales para mantener
correctas las llamadas anidadas y el comportamiento del juego.

Las limitaciones son un nivel fijo, puntaje máximo común de cien y récord
solo en memoria. Como mejoras futuras pueden incorporarse niveles, un bonus
según movimientos y almacenamiento del récord en disco. Para la entrega
actual, la prioridad es que las evidencias manuales documenten con claridad
la versión compilada y que cada integrante pueda explicar sus decisiones.

## Referencias del proyecto

Enunciado Proyecto 2 EIF205 2026, Universidad Nacional, proporcionado por el
curso. Código fuente del repositorio del grupo Maze8086 EIF205, ramas de
interfaz, movimiento, juego e integración. La documentación local de EMU8086
incluye las referencias de instrucciones e interrupciones utilizadas.

Repositorio revisado como referencia inicial:
https://github.com/ramaadarsh/MICROPROCESOR-EMU8086-ASSEMBLY-LANGUAGE

La versión del grupo organiza sus propios módulos, mapa y estados. El equipo
debe distinguir en la exposición entre la referencia consultada y sus aportes
concretos, respaldados por su historial de Git.
