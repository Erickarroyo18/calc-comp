
# Evaluador *Eager*: Semántica Natural y Máquina Abstracta con Call-by-Value

Este directorio contiene la primera implementación práctica desarrollada como parte del trabajo escrito (`docs/Tesis.pdf`). El objetivo es modelar un lenguaje funcional con evaluación ansiosa (*eager evaluation*) y paso de parámetros por valor (*call-by-value*), utilizando semántica natural (*big-step semantics*) y una máquina abstracta basada en pila.

---

## Estructura del Proyecto

- `Eval.hs`: Evaluador directo utilizando semántica natural.
- `Alanis.hs`: Máquina abstracta y compilador asociado.

---

## Descripción Técnica

### `Eval.hs`

Este módulo define la semántica del lenguaje mediante evaluación directa sobre ambientes, siguiendo el estilo de semántica natural.

#### Sintaxis Abstracta (`Expr`)

```haskell
data Expr
  = Num Int
  | Boolean Bool
  | Var String
  | Add Expr Expr
  | Sub Expr Expr
  | Mul Expr Expr
  | Div Expr Expr
  | Eq  Expr Expr
  | If  Expr Expr Expr
  | Pair Expr Expr
  | Fst Expr
  | Lambda String Expr
  | App Expr Expr
```

#### Valores Semánticos (`Value`)

```haskell
data Value
  = NumV Int
  | BooleanV Bool
  | PairV Value Value
  | Closure String Expr Env
  | Error
```

#### Evaluador

```haskell
eval :: Expr -> Env -> Value
```

- Implementa la evaluación de expresiones a valores finales.
- Utiliza un entorno (`Env`) para el manejo de variables.
- Los errores de ejecución (como división por cero o variables libres) se propagan mediante el valor `Error`.

---

### `Alanis.hs`

Este módulo implementa una máquina abstracta de pila y un compilador que transforma expresiones del lenguaje a código ejecutable.

#### Instrucciones de Máquina (`Code`)

```haskell
data Code
  = PUSHN Int | PUSHB Bool
  | ADD | SUB | MUL | DIV | EQ
  | PAIR | FST
  | IF Code Code
  | LAMBDA Code | LOOKUP String
  | APP | RET | HALT
```

#### Compilador

```haskell
comp  :: Expr -> Code
comp' :: Expr -> Code -> Code
```

- `comp` genera código ejecutable desde una expresión.
- `comp'` aplica estilo de compilación con continuaciones.

#### Máquina de Ejecución

```haskell
exec :: Code -> Conf -> Conf
```

- Evalúa instrucciones sobre una configuración (`Conf`) compuesta por una pila de valores y un entorno.
- Los elementos de la pila (`Elem`) pueden representar valores o cierres.

---

## Instrucciones de Uso

### Evaluación directa (semántica natural)

1. Iniciar GHCi e importar el módulo:

   ```bash
   ghci Eval.hs
   ```

2. Evaluar expresiones:

   ```haskell
   ghci> eval (Fst (Pair (Add (Num 7) (Num 0)) (Boolean True))) []
   -- Resultado: NumV 7

   ghci> eval (Fst (Pair (Div (Num 8) (Num 0)) (Boolean True))) []
   -- Resultado: Error
   ```

---

### Evaluación mediante máquina abstracta

1. Iniciar GHCi:

   ```bash
   ghci Alanis.hs
   ```

2. Compilar y ejecutar una expresión:

   ```haskell
   ghci> let e = Fst (Pair (Add (Num 7) (Num 0)) (Boolean True))
   ghci> let c = comp e
   ghci> exec c ([], [])
   -- Resultado: ([VAL (NumV 7)], [])
   ```

3. Manejo de errores:

   ```haskell
   ghci> let e = Fst (Pair (Div (Num 8) (Num 0)) (Boolean True))
   ghci> exec (comp e) ([], [])
   -- Resultado: *** Exception: División por cero
   ```

---

## Observaciones

- Esta implementación constituye la base para validar experimentalmente la semántica natural con evaluación *call-by-value*.
- El diseño de la máquina abstracta permite modelar explícitamente ambientes y control de flujo, facilitando la extensión hacia estrategias más complejas (como evaluación *lazy*).
- El código está escrito en *Haskell* (versión 9.6 o superior) y pensado para ejecutarse en GHCi.

---

## Referencias

- Trabajo escrito, sección 3: *Caso de Estudio 1: Aλanis*.
- Documentación de GHC: [https://www.haskell.org/ghc/](https://www.haskell.org/ghc/)

---

## Requisitos

- GHC 9.6+
- GHCi
- Sistema operativo Linux, macOS o Windows
