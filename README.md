# Cálculo de Compiladores Correctos

Este repositorio contiene la implementación de los resultados y casos de estudio presentados en el trabajo escrito sobre el **Cálculo de Compiladores Correctos: Del Régimen Estricto al Perezoso**, siguiendo la metodología desarrollada por **Patrick Bahr** y **Graham Hutton** en su artículo *Calculating Correct Compilers* (JFP, 2015). El proyecto abarca una serie de lenguajes de programación funcionales, desde versiones simples hasta lenguajes extendidos con características como la recursión explícita y distintas estrategias de evaluación, todo ello con un enfoque en la corrección formal de los compiladores y las máquinas virtuales generadas.

---

## Objetivo del Repositorio

El objetivo principal de este repositorio es proporcionar una **implementación práctica** y **verificable** de los compiladores correctos definidos en el trabajo escrito. A lo largo de este repositorio, se implementan lenguajes de programación y sus correspondientes compiladores, aplicando el **cálculo de compiladores correctos** tal como se describe en la metodología de Bahr y Hutton. Cada caso de estudio se deriva de la especificación semántica formal de un lenguaje, pasando por un proceso de **desazucarado** (simplificación de la sintaxis) y **compilación** hasta llegar a una **máquina virtual**.

Cada subdirectorio en este repositorio corresponde a un lenguaje distinto, o a una variante de un lenguaje que emplea un régimen de evaluación diferente. A continuación, se presenta una descripción general de la estructura del repositorio.

---

## Estructura del Repositorio

El repositorio se organiza en los siguientes directorios principales:

### `eager/`
Implementación del lenguaje **Aλanis** con régimen de evaluación **Call-by-Value** (evaluación ansiosa). Incluye los módulos que definen el evaluador, el compilador y la máquina virtual correspondientes.

- `Alanis.hs`: Implementación del lenguaje Aλanis.
- `Eval.hs`: Evaluador semántico del lenguaje.
- `README.md`: Documentación específica del subdirectorio.

### `lazy/`
Implementación del lenguaje **Iris** con régimen de evaluación **Call-by-Name** (evaluación perezosa). Al igual que en el directorio anterior, se incluyen los módulos de evaluación, compilación y máquina virtual.

- `Iris.hs`: Implementación del lenguaje Iris.
- `Eval.hs`: Evaluador semántico del lenguaje.
- `README.md`: Documentación específica del subdirectorio.

### `miniB/`
Implementación del minilenguaje booleano **MiniB**, con soporte para evaluación directa, compilador y máquina virtual derivada.

- `Eval.hs`: Evaluador semántico para expresiones booleanas.
- `MiniB.hs`: Máquina virtual y compilador para MiniB.
- `README.md`: Documentación específica del subdirectorio.
- `extended/`: Extensión del lenguaje MiniB con sintaxis concreta y desazucarado lógico.

### `recursion/`
Implementación de lenguajes funcionales extendidos con **recursión explícita**. Incluye dos variantes con distintos regímenes de evaluación: **Call-by-Name** (Iris) y **Call-by-Value** (Aλanis).

- `cbn/`: Implementación del lenguaje Iris con recursión explícita y evaluación perezosa.
- `cbv/`: Implementación del lenguaje Aλanis con recursión explícita y evaluación ansiosa.
- `README.md`: Documentación sobre los lenguajes recursivos y su implementación.

---

## Enfoque de Cálculo de Compiladores Correctos

A través de esta metodología, se desarrollan compiladores correctos por construcción, asegurando que las máquinas virtuales generadas mantengan la semántica del lenguaje fuente.

El proceso de cálculo sigue los siguientes pasos:

1. **Especificación del Lenguaje Fuente**: Definición de la semántica del lenguaje mediante una gramática y una semántica operacional.
2. **Desazucarado**: Eliminación de azúcar sintáctica, transformando las construcciones complejas del lenguaje en una forma más básica y manejable. Aunque opcional
en terminos del método, es útil para la integración dey desarrollo más general de los compiladores derivados.
3. **Compilación**: Desarrollo de un compilador que traduce las expresiones del lenguaje fuente a una representación intermedia, típicamente un conjunto de instrucciones para una máquina virtual.
4. **Máquina Virtual**: Implementación de la máquina virtual que ejecuta el código compilado, evaluando las expresiones de acuerdo con la semántica definida.

Cada subdirectorio sigue este esquema, implementando el lenguaje, su compilador y su máquina virtual de acuerdo con los principios establecidos en la tesis.

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

