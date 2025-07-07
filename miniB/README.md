# Lenguaje MiniB

Este directorio presenta un minilenguaje de expresiones booleanas como parte del marco teórico de la tesis. Se incluye su evaluador directo, un compilador y una máquina virtual basada en pila, construidos mediante el proceso de cálculo de compiladores.

---

## Contenido del directorio

- **`Eval.hs`**  
  Evaluador semántico directo para expresiones booleanas.

- **`MiniB.hs`**  
  Implementación de la máquina virtual y del compilador que traduce expresiones a código ejecutable.

---

## Descripción técnica

### `Eval.hs`

Define la sintaxis abstracta del lenguaje y un evaluador directo alineado con su semántica lógica clásica.

**Sintaxis abstracta (`Expr`)**:
- `Val Bool` — valores constantes
- `Not Expr` — negación lógica
- `And Expr Expr` — conjunción lógica
- `Or Expr Expr` — disyunción lógica

**Evaluador**:
- `eval :: Expr -> Bool`  
  Evalúa expresiones booleanas de manera directa, siguiendo las reglas semánticas del lenguaje.

---

### `MiniB.hs`

Extiende el modelo con una máquina de pila e introduce el proceso de compilación de expresiones booleanas.

**Código de máquina (`Code`)**:
- Instrucciones: `PUSH`, `NOT`, `AND`, `OR`, `HALT`

**Compilador**:
- `comp :: Expr -> Code`  
  Traduce expresiones del lenguaje fuente a código de máquina.

**Máquina de ejecución (`exec`)**:
- `exec :: Code -> Stack -> Stack`  
  Ejecuta un programa sobre una pila de evaluación, procesando las instrucciones generadas por el compilador.

Este diseño ilustra el ciclo completo de interpretación, compilación y ejecución para un lenguaje lógico minimalista.

---

## Instrucciones de compilación y uso

### Evaluador directo (`Eval.hs`)

1. Abrir `GHCi` e importar el módulo:
```bash
ghci Eval.hs
```
2. Evaluar una expresión:
```bash
ghci> eval (And (Val True) (Not (Val False)))
True
```

---

### Máquina virtual y compilador (`MiniB.hs`)

1. Iniciar GHCi:
```bash
ghci MiniB.hs
```
2. Compilar y ejecutar una expresión:
```bash
ghci> let expr = Or (Val True) (And (Val False) (Val True))
ghci> let code = comp expr
ghci> exec code []
[True]
```

---

## Observaciones

Este módulo constituye una instancia básica del proceso de derivación de compiladores a partir de semánticas formales. Se utiliza como punto de partida conceptual antes de abordar lenguajes más complejos como `Iris` y `Aλanis`.

Se recomienda utilizar GHCi para realizar pruebas adicionales y validar expresiones booleanas complejas.

---

## Referencias

- Marco teórico del proyecto Sección 2.
- Lenguaje de implementación: Haskell 9.6+ (GHC).
- Documentación oficial: [https://www.haskell.org/ghc/](https://www.haskell.org/ghc/)
