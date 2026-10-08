# Plan de trabajo — Metodología AI-DLC

**Proyecto:** Tarea 1 — Escena base y modelo generado con IA (Godot 4.7.2)
**Metodología:** AI-DLC (AI Development Life Cycle) — fases iterativas con el
humano como director y la IA como ejecutora, aprobando cada "bolt" (iteración
corta) antes de avanzar.

---

## Fase 1 — Inception (Intención e Inception)

**Objetivo:** fijar requisitos y criterios de aceptación, y descomponer en
unidades de trabajo pequeñas y verificables.

### Requisitos (del enunciado)
1. Entorno: suelo + obstáculos `StaticBody3D`, cielo procedural, luz direccional
   con sombras. Escenas editables.
2. `CharacterBody3D`: movimiento relativo a cámara, gravedad, salto solo en
   suelo. Separar física de visual. Explicar `delta`.
3. Cámara: seguimiento + tratamiento de obstáculos (`SpringArm3D` nativo).
4. FSM: Idle / Walk / Jump, transiciones explícitas, estado visible.
5. Modelo IA: generar con Tripo/Meshy, revisar malla/escala/normales/
   materiales/articulaciones, escena envolvente separada del controlador.
6. Trazabilidad: prompt exacto, herramienta, fecha, ajustes, procedencia,
   correcciones.

### Criterios de aceptación (mapeados a pruebas)
- CA1: moverse y saltar junto a suelo/esquinas/obstáculos sin atravesarlos ni
  saltar infinitamente en el aire.
- CA2: girar cámara y mantener la referencia de movimiento; cámara no atraviesa
  paredes.
- CA3: Idle→Walk→Jump→Idle; comparar desplazamiento en intervalo fijo con dos
  límites de render distintos y explicar diferencias.
- CA4: abrir copia del proyecto y verificar modelo, materiales, escala y
  ausencia de archivos faltantes.

### Descomposición en unidades de trabajo (bolts)
| # | Unidad | Estado |
|---|--------|--------|
| B1 | Entorno de desarrollo (Godot 4.7.2) | ✅ |
| B2 | Scaffolding + `project.godot` + inputs | ✅ |
| B3 | Escena de nivel (entorno/luz/colisiones) | ✅ |
| B4 | Controlador `CharacterBody3D` + delta | ✅ |
| B5 | Cámara `SpringArm3D` | ✅ |
| B6 | FSM Idle/Walk/Jump + indicador | ✅ |
| B7 | Escena envolvente del modelo (placeholder) | ✅ |
| B8 | Documentación y trazabilidad | ✅ |
| B9 | Generar modelo real en Tripo/Meshy e integrarlo | ⬜ (requiere tu acción) |
| B10 | Capturas, video y exportar PDF | ⬜ (requiere tu acción) |

---

## Fase 2 — Construction (Construcción)

Para cada bolt: **diseño → generación → verificación**.

- **Diseño:** arquitectura de escenas separando nivel / personaje / modelo
  (ver README).
- **Generación:** scripts GDScript (`player.gd`, `camera_rig.gd`) y escenas
  `.tscn`. La **lógica del personaje la escribimos nosotros**, no se delega a la
  IA generadora (requisito del enunciado). La IA solo produce el **modelo 3D**.
- **Verificación realizada:**
  - `godot --headless --import` → importa sin errores.
  - `godot --headless --quit-after 120` → ejecuta sin errores de script;
    la consola muestra transiciones de FSM `IDLE -> JUMP -> IDLE`.

---

## Fase 3 — Operations (Operación / Entrega)

- Documentación: `README.md`, `docs/documento_entrega.md` (base del PDF),
  `docs/ficha_modelo.md`.
- Trazabilidad del modelo: carpeta `prompts/` con prompt exacto, bitácora y
  comparación antes/después.
- Pendiente del usuario: generar el `.glb`, tomar 3 capturas, grabar el video
  (1–2 min), exportar el PDF y publicar el repositorio.

---

## Pasos que debes hacer tú (no automatizables desde aquí)

1. **Generar el modelo** en [Tripo](https://www.tripo3d.ai) o
   [Meshy](https://www.meshy.ai) usando el prompt de `prompts/prompt_modelo.md`.
   Exportar `.glb` (con normales y materiales) a `assets/models/`.
2. **Integrar:** abrir `scenes/character_model.tscn`, arrastrar el `.glb` como
   hijo de un nodo raíz, ajustar escala (~1.8 m de alto) y borrar el placeholder.
3. **Revisar** malla, escala, normales, materiales y articulaciones; registrar
   en `docs/ficha_modelo.md` y `prompts/comparacion_antes_despues.md`.
4. **Probar** CA1–CA4 dentro del editor.
5. **Capturas** (3) + **video** (1–2 min) + **exportar PDF** desde
   `docs/documento_entrega.md`.
6. **Repositorio:** `git init`, commit y push (ver sección en el documento de
   entrega).
