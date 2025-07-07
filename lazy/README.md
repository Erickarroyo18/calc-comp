# Lenguaje Iris

Este repositorio contiene la segunda implementación de caso de estudio asociada al trabajo de tesis. Se modela un lenguaje con régimen de evaluación perezoso (*lazy evaluation*) y estrategia de paso de parámetros por nombre (*Call-by-Name*), utilizando una semántica estructural (*small-step semantics*) y una máquina virtual de pila.

---

## Estructura del proyecto

- `Eval.hs`: Evaluador basado en reducción paso a paso sobre configuraciones de ejecución.
- `Iris.hs`: Máquina virtual de pila para evaluación perezosa y compilador asociado.

---

## Descripción técnica

### `Eval.hs`

Este módulo implementa la evaluación de expresiones mediante una semántica estructural. Modela explícitamente construcciones de evaluación diferida mediante *thunks* y sus forzamientos.

#### Sintaxis abstracta (`Expr`)

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

#### Valores finales (`Value`)

```haskell
data Value
   = NumV Int
   | BooleanV Bool
   | PairV Value Value
   | Closure Expr Env
   | Thunk Expr Env
   | ErrorV
```

#### Modelo de evaluación

- `Config`: configuración de ejecución compuesta por una expresión en tiempo de ejecución (`RTExpr`) y un entorno (`Env`).
- `RTExpr`: incluye formas activas de evaluación como suspensiones (`T`), forzamientos (`F`), cierres (`C`), y expresiones evaluadas (`S`).
- `step :: Config -> Maybe Config`: realiza un paso de reducción sobre una configuración.
- `eval :: Expr -> Env -> Value`: evalúa expresiones mediante la aplicación sucesiva de pasos pequeños hasta llegar a un valor canónico.

La implementación refleja el comportamiento de *Call-by-Name* con suspensiones diferidas que solo se evalúan cuando es necesario.

---

### `Iris.hs`

Este módulo define una máquina virtual orientada a evaluación perezosa, siguiendo la misma semántica estructural de `Eval.hs`.

#### Instrucciones de máquina (`Code`)

```haskell
data Code = HALT
          | PUSHN Int Code
          | PUSHB Bool Code
          | LOOKUP String Code
          | ADD Code
          | SUB Code
          | MUL Code
          | DIV Code
          | EQ Code
          | IF Code Code
          | FORCE Code
          | CEV
          | RET
          | FST Code
          | PAIR Code Code Code
          | ABS Code Code
          | LAMBDA String Code
          | APP Code Code
```

#### Compilador

```haskell
comp  :: Expr -> Code
comp' :: Expr -> Code -> Code
```

- `comp` traduce expresiones a código de máquina.
- `comp'` permite la construcción incremental del código usando continuaciones.

#### Modelo de ejecución

- `Conf = (Stack, Env)`: la configuración consta de una pila de evaluación y un entorno.
  - `Stack`: contiene elementos `Elem`, que pueden ser valores, cierres o thunks.
  - `Env`: ambiente de evaluación con asociaciones entre variables y valores diferidos.

```haskell
exec :: Code -> Conf -> Conf
```

- Ejecuta instrucciones desde una configuración inicial, evaluando construcciones diferidas y controlando forzamientos explícitos mediante instrucciones `FORCE` y `CEV`.

La máquina de `Iris` proporciona un modelo claro y controlado de evaluación diferida, reproduciendo el comportamiento semántico esperado del evaluador `Eval.hs`.

---

## Instrucciones de compilación y uso

### Evaluador (`Eval.hs`)

1. Iniciar GHCi e importar el módulo:

   ```bash
   ghci Eval.hs
   ```

2. Evaluar una expresión:

   ```haskell
   ghci> eval (Fst (Pair (Add (Num 7) (Num 0)) (Boolean True))) []
   -- Resultado: Thunk (Add (Num 7) (Num 0)) []
   ```

3. Evaluación con división por cero:

   ```haskell
   ghci> eval (Fst (Pair (Div (Num 8) (Num 0)) (Boolean True))) []
   -- Resultado: Thunk (Div (Num 8) (Num 0)) []
   ```

---

### Máquina virtual (`Iris.hs`)

1. Iniciar GHCi:

   ```bash
   ghci Iris.hs
   ```

2. Compilar y ejecutar una expresión:

   ```haskell
   ghci> let e = Fst (Pair (Add (Num 7) (Num 0)) (Boolean True))
   ghci> let c = comp e
   ghci> exec c ([], [])
   -- Resultado: ([VAL (Thunk (PUSHN 7 (FORCE (PUSHN 0 (FORCE (ADD CEV))))) [])], [])
   ```

3. Evaluación con posible error:

   ```haskell
   ghci> let e = Fst (Pair (Boolean True) (Div (Num 8) (Num 0)))
   ghci> let c = comp e
   ghci> exec c ([], [])
   -- Resultado: ([VAL (Thunk (PUSHB True CEV) [])], [])
   ```

---

## Observaciones

Esta implementación permite validar de manera operativa el modelo teórico de evaluación *lazy*, mediante la reducción estructural controlada y el uso de *thunks*. La separación entre suspensiones y forzamientos permite simular con precisión el comportamiento de *Call-by-Name*, y facilita la observación del orden de evaluación y su impacto.

Comparado con la versión *eager*, esta variante introduce una abstracción más compleja en la gestión del ambiente y de la pila, orientada al diferimiento explícito de cómputo.

---

## Referencias

- Sección 4: *Caso de Estudio 2: Iris*.
- Lenguaje de implementación: Haskell 9.6+ (GHC).
- Documentación oficial: [https://www.haskell.org/ghc/](https://www.haskell.org/ghc/)
