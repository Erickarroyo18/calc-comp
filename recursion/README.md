# Lenguajes Recursivos: Estrategias *Call-by-Name* y *Call-by-Value*

Este directorio contiene dos extensiones del lenguaje funcional base con soporte para recursión explícita. Cada variante implementa un régimen de evaluación distinto: **evaluación perezosa** con estrategia de paso de parámetro por nombre (*Call-by-Name*) y **evaluación ansiosa** con paso por valor (*Call-by-Value*). Ambas versiones comparten una gramática concreta común y una interfaz sintáctica unificada, diferenciándose únicamente en la semántica operativa subyacente.

---

## Estructura del Proyecto

El proyecto está organizado en los siguientes subdirectorios:

- **`cbn/`** — Implementación de **Iris**, lenguaje con evaluación perezosa (*Call-by-Name*).
- **`cbv/`** — Implementación de **Aλanis**, lenguaje con evaluación ansiosa (*Call-by-Value*).

Cada subdirectorio contiene los siguientes módulos:

- **`Grammars.y`**  
  Gramática concreta del lenguaje extendido. Define la sintaxis para funciones recursivas mediante la construcción `Rec f x -> e`.

- **`Grammars.hs`**  
  Archivo generado automáticamente por *Happy*. Se incluye para evitar la necesidad de recompilar el parser.

- **`Desugar.hs`**  
  Módulo de desazucarado. Implementa la transformación `Rec f x -> e` a su forma canónica mediante operadores de punto fijo:
  - `Y` para *Iris* (evaluación perezosa)
  - `Z` para *Aλanis* (evaluación ansiosa)  
  Estas transformaciones se formalizan en la Sección 9.4 del trabajo escrito.

- **`Iris.hs`** / **`Aλanis.hs`**  
  Semántica del lenguaje correspondiente. Define:
  - Representación de expresiones (`Expr`)
  - Valores (`Value`)
  - Ambientes (`Env`)
  - Reglas de evaluación según el régimen correspondiente

- **`LambdaCBName.hs`** / **`LambdaCBValue.hs`**  
  Módulos principales. Encapsulan el flujo completo: parsing, desazucarado y evaluación. Proveen la función de entrada `run`.

---

## Evaluación de Programas

Ambas variantes del lenguaje permiten evaluar programas escritos en sintaxis concreta mediante la función:

```haskell
run :: String -> Value
```

---

## Instrucciones de Uso

### Requisitos

- [GHC 9.6 o superior](https://www.haskell.org/ghc/)
- [Happy](https://www.haskell.org/happy/) (solo si se recompila el parser)

### Evaluación

1. (Opcional) Regenerar el parser:
```bash
happy Grammars.y
```

2. Iniciar GHCi y cargar el evaluador correspondiente:

- *Iris* (evaluación perezosa):
```bash
cd cbn
ghci LambdaCBName.hs
```
Opcionalmente usar el comando:
````
ghci -package array LambdaCBName.hs 
````
- *Aλanis* (evaluación ansiosa):
```bash
cd cbv
ghci LambdaCBValue.hs
```
Opcionalmente usar el comando:
````
ghci -package array LambdaCBValue.hs
````
3. Evaluar un programa:
```haskell
ghci> run "(Rec fact (Lambda n (if (= n 0) 1 (* n (fact (- n 1))))) (fact 5))"
NumV 120
```

O utilizar expresiones predefinidas como `testFact`:
```haskell
ghci> run testFact
NumV 120
```

---

## Observaciones

Estas variantes extienden los lenguajes previamente definidos con un mecanismo explícito de recursión basado en operadores de punto fijo (`Y`, `Z`). Las transformaciones sintácticas y semánticas están justificadas formalmente en la Sección 9.4 del trabajo escrito.

El comportamiento de los programas difiere entre *Iris* y *Aλanis* debido a la estrategia de evaluación adoptada:
- **Iris**: *Call-by-Name* — argumentos no evaluados hasta ser necesarios.
- **Aλanis**: *Call-by-Value* — argumentos evaluados antes de aplicar la función.

Estas diferencias afectan la eficiencia, terminación y trazas de evaluación de programas recursivos.

---

## Referencias

- Trabajo escrito — Sección 9.4: *"Recursión en lenguajes funcionales"*
- Capítulos anteriores — Definición formal de *Iris* y *Aλanis*
- Documentación de Happy: https://www.haskell.org/happy/
- Herramientas utilizadas: GHCi, Happy, Haskell estándar
