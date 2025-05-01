# MiniB (Extendido): Sintaxis Concreta y Desazucarado para Expresiones Booleanas

Este subdirectorio extiende el lenguaje `MiniB` incorporando un analizador sintáctico generado con *Happy*, lo que permite evaluar expresiones escritas en sintaxis concreta. Además, implementa una fase de desazucarado para transformar operadores lógicos extendidos (como la implicación y la equivalencia) a una forma básica basada en conjunciones, disyunciones y negaciones.

---

## Contenido del Directorio

- **`Grammars.y`**  
  Especificación de la gramática del lenguaje para el generador de parsers *Happy*. Define la sintaxis concreta de expresiones booleanas, incluyendo operadores como `=>` (implicación) y `<=>` (equivalencia).

- **`Grammars.hs`**  
  Código Haskell generado automáticamente por *Happy*. Se incluye para facilitar la ejecución sin necesidad de regenerar el parser manualmente.

- **`MiniB.hs`**  
  Máquina virtual basada en pila y compilador de expresiones booleanas en su forma básica.

- **`Extended.hs`**  
  Encapsula todo el flujo de ejecución: análisis léxico, parsing, desazucarado, compilación y evaluación. Define la función principal `run :: String -> [Bool]`.

- **`Desugar.hs`**  
  Implementa la transformación de expresiones con operadores extendidos a expresiones canónicas del lenguaje base.

---

## Transformación de Sintaxis Extendida

El módulo `Desugar.hs` define la función:

```haskell
desugar :: CST -> Expr
```

que convierte expresiones con operadores extendidos a una forma normal compuesta exclusivamente por negación (`¬`), conjunción (`∧`) y disyunción (`∨`).

**Reglas de desazucarado** (Sección 2.4.2. del trabajo escrito):

- `desugar(True) = True`
- `desugar(False) = False`
- `desugar(not A) =  desugar(A)`
- `desugar(A ∧ B) = desugar(A) ∧ desugar(B)`
- `desugar(A ∨ B) = desugar(A) ∨ desugar(B)`
- `desugar(A → B) = ¬ desugar(A) ∨ desugar(B)`
- `desugar(A ↔ B) = (desugar(A) ∧ desugar(B)) ∨ (¬ desugar(A) ∧ ¬ desugar(B))`

Estas transformaciones preservan la semántica clásica de las expresiones, permitiendo su compilación en el entorno base de `MiniB`.

---

## Instrucciones de Compilación y Uso

### Evaluación desde Sintaxis Concreta (`Extended.hs`)

1. Abrir GHCi:
```bash
ghci Extended.hs
```

2. Evaluar una expresión:
```haskell
ghci> run "(True <=> (False => (not True)))"
True
```

La función `run` realiza internamente las siguientes etapas:

1. Análisis sintáctico mediante el parser generado a partir de `Grammars.y`.
2. Desazucarado de la expresión con `desugar`.
3. Compilación a código de máquina.
4. Ejecución en la máquina virtual de `MiniB.hs`.

---

## Requisitos

- [GHC 9.6+](https://www.haskell.org/ghc/)
- [Happy](https://www.haskell.org/happy/) (solo necesario si se desea recompilar el parser)

---

## Observaciones

Este subdirectorio permite la evaluación de expresiones booleanas escritas en una sintaxis más cercana a la notación lógica usual, y ejemplifica el proceso de desazucarado como etapa intermedia entre la sintaxis concreta y la ejecución operativa.

El diseño está respaldado por los fundamentos teóricos presentados en `Tesis.pdf`, particularmente en la Sección 2.4.2. Se recomienda revisar dicho material para comprender las motivaciones y formalización de las transformaciones implementadas.

---

## Referencias

- Tesis del proyecto — Sección 2.4.2: "Azúcar Sintáctica"
- Documentación de Happy: https://www.haskell.org/happy/
- Herramientas: GHCi, Happy, Haskell
