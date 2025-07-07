# Documentación Técnica del Proyecto

Este directorio contiene el trabajo escrito principal del proyecto, junto con sus apéndices técnicos. La documentación complementa las distintas implementaciones del repositorio, proporcionando el marco formal, los fundamentos semánticos y los cálculos detallados que sustentan las decisiones de diseño.

---

## Archivos Incluidos

- **`Tesis.pdf`**  
  Documento central del proyecto. Presenta el marco teórico, las definiciones semánticas, los lenguajes desarrollados (`Iris` y `Aλanis`), y el análisis de sus propiedades. Sirve como referencia principal para las implementaciones contenidas en los subdirectorios `/eager`, `/lazy`, `/cbv` y `/cbn`.

- **`apendiceAlanis.pdf`**  
  Apéndice técnico con los desarrollos completos correspondientes al lenguaje `Aλanis` (evaluación ansiosa). Incluye el diseño detallado del compilador y de la máquina de ejecución, omitiendo explicaciones conceptuales.

- **`apendiceIris.pdf`**  
  Apéndice técnico con los cálculos completos del lenguaje `Iris` (evaluación perezosa), centrado en la presentación operativa y la correspondencia con la semántica estructural.

---

## Requisitos de Lectura

La documentación está orientada a lectores con formación básica en teoría de lenguajes de programación, compiladores y semántica formal. Se recomienda tener familiaridad con los siguientes conceptos:

- Estrategias de evaluación y paso de parámetros
- Semántica natural vs. semántica estructural
- Cierres (closures) y ambientes de ejecución
- Máquinas abstractas y compilación de lenguajes funcionales

Los apéndices están destinados a lectores que deseen verificar completamente las herramientas semánticas y operacionales descritas, sin necesidad de explicaciones pedagógicas adicionales.

---

## Recomendaciones de Lectura

La arquitectura general del proyecto y la motivación de sus distintos componentes están desarrolladas en `Tesis.pdf`. Se sugiere comenzar con ese documento antes de explorar los módulos de código fuente.

Cada subdirectorio del repositorio incluye un `README.md` con referencias cruzadas a secciones relevantes de la tesis, facilitando la navegación entre teoría e implementación.

---
