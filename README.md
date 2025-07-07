# Cálculo de Compiladores Correctos

Este repositorio contiene la implementación de los resultados y casos de estudio presentados en el trabajo **Cálculo de Compiladores Correctos: Del Régimen Estricto al Perezoso**, siguiendo la metodología propuesta por **Patrick Bahr** y **Graham Hutton** en su artículo *Calculating Correct Compilers* (JFP, 2015).  
El proyecto abarca una serie de lenguajes funcionales, desde versiones básicas hasta extensiones con recursión explícita y distintas estrategias de evaluación, haciendo énfasis en la **corrección formal** de los compiladores y las máquinas virtuales generadas.

---

## Objetivo del repositorio

El propósito principal de este repositorio es ofrecer una **implementación práctica y verificable** de compiladores correctos, derivados directamente de las definiciones semánticas de los lenguajes. Se aplican los principios del cálculo de compiladores correctos para desarrollar, a partir de una semántica formal, compiladores y máquinas virtuales que preservan dicha semántica.  

Cada caso de estudio parte de una especificación del lenguaje fuente, seguido por un proceso de **desazucarado** (cuando es necesario) y **compilación**, culminando en una **máquina virtual** que ejecuta el código generado.

---

## Estructura del repositorio

El repositorio se organiza en los siguientes subdirectorios, cada uno correspondiente a un lenguaje específico o una variante con diferente régimen de evaluación:

### `eager/`
Lenguaje **Aλanis**, con evaluación ansiosa y paso de parámetros por valor (**Call-by-Value**). Incluye:

- `Alanis.hs`: Definición del lenguaje.
- `Eval.hs`: Evaluador semántico.
- `README.md`: Documentación específica.

### `lazy/`
Lenguaje **Iris**, con evaluación perezosa y paso de parámetros por nombre (**Call-by-Name**). Incluye:

- `Iris.hs`: Definición del lenguaje.
- `Eval.hs`: Evaluador semántico.
- `README.md`: Documentación específica.

### `miniB/`
Minilenguaje booleano **MiniB**, con evaluación directa, compilador derivado y máquina virtual. Incluye:

- `MiniB.hs`: Definición de compilador y máquina virtual.
- `Eval.hs`: Semántica directa.
- `extended/`: Versión extendida con sintaxis concreta y desazucarado.
- `README.md`: Documentación específica.

### `recursion/`
Lenguajes extendidos con **recursión explícita**, disponibles en dos variantes según el régimen de evaluación:

- `cbn/`: Versión de **Iris** con operador *Y* y evaluación perezosa.
- `cbv/`: Versión de **Aλanis** con operador *Z* y evaluación ansiosa.
- `README.md`: Documentación detallada.

---

## Enfoque del Cálculo de Compiladores Correctos

La metodología aplicada en este repositorio permite derivar compiladores correctos **por construcción**, asegurando que las máquinas virtuales ejecutan el código compilado conforme a la semántica original del lenguaje fuente.

El proceso se divide en las siguientes etapas:

1. **Especificación del lenguaje**: Se definen las sintaxis concreta y abstracta mediante una gramática.
2. **(Opcional) Desazucarado**: Las construcciones complejas o recursivas son traducidas a formas básicas utilizando transformaciones previas a la compilación. Aunque no es un paso esencial del método, facilita la implementación modular de lenguajes con sintaxis extendida.
3. **Compilación**: Se traduce la sintaxis abstracta a una secuencia de instrucciones para una máquina virtual, respetando la semántica del lenguaje.
4. **Máquina virtual**: Se implementa un intérprete que ejecuta el código compilado bajo el régimen de evaluación correspondiente.

Cada subdirectorio sigue esta estructura general, presentando de forma clara la semántica, compilador y máquina virtual del lenguaje considerado, en línea con los principios establecidos en el trabajo original.

---

## Requisitos

Para poder ejecutar y explorar los ejemplos contenidos en este repositorio, se necesita lo siguiente:

- **GHC (Glasgow Haskell Compiler)** versión 9.6 o superior.
- **Happy**: Utilizado para la generación de analizadores léxicos y sintácticos (solo necesario si se desea regenerar los parsers).
- **Haskell estándar**: El proyecto se basa completamente en Haskell estándar, sin dependencias externas.

---

## Uso y Ejecución

El repositorio está diseñado para su uso en **GHCi** (el intérprete interactivo de GHC), lo que permite evaluar expresiones de manera interactiva. Cada subdirectorio contiene su propia documentación y ejemplos para facilitar el uso del sistema y la experimentación con los lenguajes y máquinas virtuales definidos.

Para empezar, basta con cargar el archivo principal en GHCi y utilizar las funciones de evaluación y compilación proporcionadas en cada subdirectorio.

---

## Referencias

- Bahr, P., & Hutton, G. (2015). *Calculating Correct Compilers*. Journal of Functional Programming, 25. [https://doi.org/10.1017/S0956796815000180](https://doi.org/10.1017/S0956796815000110)
- Repositorio original en Coq: [https://github.com/pa-ba/calc-comp](https://github.com/patrickbahr/correct-compilers-coq)

---

## Licencia

Este repositorio está disponible con fines académicos y educativos. Se permite la reutilización, modificación y distribución, siempre y cuando se dé crédito adecuado al trabajo original y a este repositorio.

