# Documentación técnica del proyecto

Este directorio contiene el trabajo escrito principal del proyecto, junto con sus apéndices técnicos. La documentación complementa las distintas implementaciones del repositorio, proporcionando el marco formal, los fundamentos semánticos y los cálculos detallados que sustentan las decisiones de diseño.

---

## Archivos Incluidos

- **`Tesis.pdf`**  
  Documento central del proyecto. Presenta el marco teórico, las definiciones semánticas, los lenguajes desarrollados (`Iris` y `Aλanis`), y el análisis de sus propiedades. Sirve como referencia principal para las implementaciones contenidas en los subdirectorios `miniB`, `/eager`, `/lazy`, `/cbv` y `/cbn`.

- **`Apendice.pdf`**  
  Apéndice técnico con los cálculos completos correspondientes a los lenguajes `Aλanis` (evaluación ansiosa) y `Iris` (evaluación perezosa). Incluye el diseño detallado del compilador y de la máquina virtual, omitiendo explicaciones conceptuales.

---

## Requisitos de lectura

La documentación está orientada a lectores con formación básica en teoría de lenguajes de programación, compiladores y semántica formal. Se recomienda tener familiaridad con los siguientes conceptos:

- Regímenes de evaluación
- Estrategias de paso de parámetros
- Semántica operacional: natural vs. estructural
- Cerraduras de función (closures) y ambientes de evaluación

Para lectores no familiarizados se recomienda revisar el capítulo 2 del archivo `Tesis.pdf` para el contexto adecuado.
El apéndice está destinado a lectores que deseen verificar completamente las herramientas semánticas y operacionales descritas, sin necesidad de explicaciones pedagógicas adicionales.

---

## Recomendaciones de lectura

La arquitectura general del proyecto y la motivación de sus distintos componentes están desarrolladas en `Tesis.pdf`. Se sugiere comenzar con ese documento antes de explorar los módulos de código fuente.

Cada subdirectorio del repositorio incluye un `README.md` con referencias cruzadas a secciones relevantes de la tesis, facilitando la navegación entre teoría e implementación.

---
