# Bitácora de pruebas manuales

Versión de interfaz revisada el 2 de noviembre de 2026.
Entorno: EMU8086 4.08 para compilar y DOSBox-X 2026.10.01 para ejecutar.
No se utilizan generadores ni programas automáticos de pruebas.

## Registro de esta revisión

| ID | Acción | Observado | Estado |
| --- | --- | --- | --- |
| P00 | Compilar maze.asm en EMU8086 | Compilación finalizada en cuatro pasadas; COM de 3135 bytes guardado en MyBuild y copiado a build/MAZE.COM | Verificado |
| P01a | Abrir el COM en DOSBox-X | Menú con título ASCII, marco doble, opciones e instrucciones visibles | Verificado visualmente |
| P01b | Iniciar con 1 en DOSBox | Tablero y panel separados; se observan 3 vidas, 5 monedas, 0 puntos y 0 movimientos | Verificado visualmente |
| P02 | Intentar atravesar una pared | Registrar antes y después | Por completar |
| P03 | Recoger moneda y volver a su celda | Registrar puntos 10 sin repetición y monedas 4 | Por completar |
| P04 | Pausar y continuar | Registrar misma posición y marcador | Por completar |
| P05 | Tocar una trampa y regresar a esa celda | Registrar vidas 2, retorno al inicio y trampa consumida | Por completar |
| P06 | Intentar salir con monedas pendientes | Registrar salida bloqueada | Por completar |
| P07 | Recoger todo y llegar a la salida | Registrar victoria y puntos 100 | Por completar |
| P08 | Tocar tres trampas distintas | Registrar derrota y vidas 0 | Por completar |
| P09 | Reiniciar después de victoria o derrota | Registrar mapa restaurado y récord conservado | Por completar |
| P10 | Q durante partida y ESC en menú | Registrar retorno al menú y salida a DOS | Por completar |

Las filas pendientes son un plan, no resultados obtenidos. La revisión visual
del menú no demuestra por sí sola victoria, derrota ni reinicio. Completar
los casos con las acciones de docs/GUIA_EVIDENCIAS.md y adjuntar los PNG.

## Registro del grupo

Copiar este formato por cada caso ejecutado:

- ID del caso:
- Fecha e integrante:
- Compilación utilizada y tamaño del COM:
- Estado inicial:
- Teclas pulsadas:
- Resultado esperado:
- Resultado observado:
- Aprobado o fallido:
- Nombre de la captura o video:
- Error encontrado y solución si corresponde:

## Errores de integración ya identificados

| Error | Impacto | Solución |
| --- | --- | --- |
| Variables con nombres distintos entre UI y reglas | Datos no compartidos | Unificar los nombres |
| Símbolos de monedas y salida inconsistentes | Mapa no coincidía con colisiones | Usar C, X y S |
| Archivo principal sin bucle | No iniciaba el juego | Conectar los estados y las llamadas |
| Montaje DOS con ruta acentuada | Carpeta no encontrada | Configuración con montaje relativo |

El récord se mantiene solo durante la ejecución. Cerrar el programa lo borra;
esto es una limitación conocida, no una prueba fallida de reinicio.
