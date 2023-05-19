---
## Avance #1: SV testbench basado en capas
---

* Estudiantes: **Kenny Wu Wen/Jorge Mora Soto/Oscar Fallas Cordero**
* Carnes: **C08592/B95222/B92861**
* Grupo: **4**
---

### *Generacion de estimulo*
Envía instrucciones para el funcionamiento del procesador. Instrucciones que respeten el estándar RISCV.
Idealmente tendría una función que retorne cada tipo de instrucción de la ISA, de modo que los segmentos de la instrucción que se puedan randomizar se calculen con ```$random``` y obtener una mayor gama de escenarios. ```stimulus.sv``` se utiliza tanto para incializar el DUV como para enviar las pruebas funcionales.
### Driver
Clase que maneja los task que se envían desde el testbench basado en capas. Sincrooniza los estímulos que se envían al procesador como al modelo de alto nivel (```reference_model.sv```). Escribe directamente en memoria como instancia al reference_model.sv

### Scoreboard
El scoreboard almacena un historial de resultados calculados por el modelo de referencia.

### Modelo de referencia
El modelo de referencia es un código que simula a alto nivel el principal funcionamiento del procesador, con el fin de obtener los resultados que se esperarían en un tiempo menor para posteriormente hacer comparación.


### Monitor
El monitor se centra en llamar los checkers para que ejecuten sus verificaciones/chequeos.
Este contiene lo siguiente:
-Checkers
-Numero de errores
-Interfaz global
-Scoreboard

### Checkers
#### Checker basado en reglas de micro-arquitectura
Este chequea reglas de micro-arquitectura de RISC-V sobre como decodificar las instrucciones de 32 bits.
Basandose en los valores obtenidos en el scoreboard, los compara con los obtenidos dentro del uRISC-V 
por medio del interfaz.


![Texto alternativo](https://github.com/Jams1001/IE0621/blob/main/diagrama.png)
