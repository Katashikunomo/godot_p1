# Tarea 1 — Escena base y modelo generado con IA

**Autor:** Andres Alexis Malfavaun Tapia — Matrícula 2203024384
**Fecha:** 7 de octubre de 2026
**Motor:** Godot 4.7.2 stable (Forward+)
**Repositorio:** https://github.com/Katashikunomo/godot_p1
**Video demo:** https://drive.google.com/file/d/1meTlnRkMq38OsSg5uFtjKwJPQqG3RFEN/view?usp=drive_link

---

## 1. Estructura de escenas

El proyecto separa tres responsabilidades en tres escenas:

- `level.tscn` — entorno (cielo procedural, luz direccional con sombras, suelo
  y obstáculos con colisiones). Instancia al personaje.
- `player.tscn` — `CharacterBody3D` con colisión cápsula, rig de cámara
  (`CameraPivot → SpringArm3D → Camera3D`), `ModelRoot` y UI de estado.
- `character_model.tscn` — escena **envolvente** del modelo generado con IA,
  independiente del controlador.

```
Level
├─ WorldEnvironment / DirectionalLight3D
├─ Floor, WallA, WallB, CrateA, CrateB, CrateC  (StaticBody3D + CollisionShape3D)
└─ Player (CharacterBody3D)
   ├─ Collision (CapsuleShape3D)
   ├─ ModelRoot → CharacterModel  (instancia envolvente)
   ├─ CameraPivot → SpringArm3D → Camera3D
   └─ DebugUI → StateLabel
```

## 2. Controles

| Acción | Entrada |
|--------|---------|
| Mover | `W A S D` / flechas |
| Saltar | `Espacio` (solo en suelo) |
| Girar cámara | Ratón |
| Liberar ratón | `Esc` |

Movimiento **relativo a la cámara**: la dirección de entrada se rota según el
yaw del `CameraPivot`.

## 3. Diagrama de la FSM

```
            (hay input, en suelo)
   ┌──────┐ ───────────────────▶ ┌──────┐
   │ IDLE │                      │ WALK │
   └──────┘ ◀─────────────────── └──────┘
      │  ▲   (sin input, en suelo)   │
      │  │                           │
 (salta / sale del suelo)      (salta / sale del suelo)
      │  │                           │
      ▼  │ (aterriza)                ▼
     ┌──────────────────────────────────┐
     │               JUMP               │
     │        (is_on_floor() == false)  │
     └──────────────────────────────────┘
```

- `IDLE`: en suelo, sin dirección.
- `WALK`: en suelo, con dirección.
- `JUMP`: en el aire (subiendo o cayendo). Al aterrizar vuelve a IDLE o WALK
  según haya input.

El estado activo se muestra en pantalla (`StateLabel`) y cada transición se
imprime en consola: `[FSM] IDLE -> JUMP`.

## 4. Explicación del movimiento y del tiempo (delta)

- **Gravedad** (aceleración, m/s²): `velocity.y -= gravity * delta`. Correcto
  multiplicar por `delta` porque es una aceleración integrada en el tiempo.
- **Velocidad horizontal:** objetivo `direction * SPEED` (m/s). Se suaviza con
  `lerpf(..., ACCEL * delta)`. La magnitud base (SPEED) **no** se multiplica por
  delta.
- **Posición:** la integra `move_and_slide()` con el delta de física interno.
  Por eso **no** volvemos a multiplicar la velocidad por delta: evitamos aplicar
  el tiempo dos veces a la misma magnitud.
- **Separación física/visual:** física en `_physics_process` (paso fijo);
  presentación en `_process`.

### Comparación con dos límites de render (CA3)
Al fijar distintos *Max FPS* (Project Settings → Application/Run → Max FPS, o
`Engine.max_fps`), el desplazamiento en un intervalo fijo es **prácticamente
igual**, porque la física corre a paso fijo (60 ticks/s) y la velocidad no
depende de los FPS de render.

Verificación determinista realizada (velocidad 5 m/s, 1 segundo simulado):

| Render FPS | Physics FPS | Desplazamiento en 1 s |
|-----------:|------------:|----------------------:|
| 30         | 60          | 5.0000 m              |
| 144        | 60          | 5.0000 m              |

**Conclusión:** el desplazamiento no depende del límite de render. Lo que cambia
con más FPS es la *suavidad* visual (más fotogramas interpolados), no la
distancia recorrida. Esto confirma que no se aplica el tiempo dos veces y que la
física es estable ante distintos límites de render.

## 5. Capturas de pruebas (3)

![Captura 1 — personaje en escena, estado IDLE junto a obstáculos](capturas/captura1.png)

*Captura 1 — El personaje (modelo IA de Tripo, texturizado) sobre el suelo,
estado `IDLE` en el HUD, obstáculos (muro y cajas) con sus sombras. Base para
verificar colisiones (CA1).*

![Captura 2 — cámara junto a pared](capturas/captura2.png)

*Captura 2 — Cámara girada junto a una pared sin atravesarla; el `SpringArm3D`
mantiene al personaje visible (CA2).*

![Captura 3 — estado WALK](capturas/captura3.png)

*Captura 3 — Indicador de estado mostrando `WALK` durante el desplazamiento, con
la transición impresa en consola (CA3).*

## 6. Enlaces

- Proyecto completo (repositorio): https://github.com/Katashikunomo/godot_p1
- Video demo (1–2 min): https://drive.google.com/file/d/1meTlnRkMq38OsSg5uFtjKwJPQqG3RFEN/view?usp=drive_link

## 7. Modelo generado con IA

Resumen (detalle en `docs/ficha_modelo.md`):
- Herramienta: **Tripo** (confirmado por nombres internos `tripo_node_*`).
- Triángulos: ~80.065 · Materiales: 1 PBR · Texturas: albedo (.jpg) +
  metallic/roughness (.png).
- Altura original ~0.98 m, escalada a ~1.8 m (factor 1.84).
- Se generó también una variante humano low-poly (~9.208 tris) conservada para
  la comparación antes/después (ver `prompts/comparacion_antes_despues.md`).
- Prompt exacto y bitácora: carpeta `prompts/`.

## 8. Pruebas de aceptación — resultados

| CA | Descripción | Resultado |
|----|-------------|-----------|
| CA1 | Moverse/saltar sin atravesar ni saltar en el aire | ✅ Colisiones por `CollisionShape3D` en suelo/muros/cajas; salto condicionado a `is_on_floor()` (no hay doble salto). Verificar visualmente con la captura 1. |
| CA2 | Girar cámara, referencia de movimiento, no atraviesa paredes | ✅ `SpringArm3D` acorta la distancia ante paredes; movimiento relativo al yaw de la cámara. Verificar con la captura 2. |
| CA3 | Idle/Walk/Jump + comparación de FPS | ✅ FSM reporta `IDLE/WALK/JUMP`; desplazamiento idéntico (5.0000 m) a 30 y 144 FPS (ver tabla arriba). |
| CA4 | Copia del proyecto: modelo/materiales/escala/sin faltantes | ✅ Importación en headless sin errores de recursos; modelo `.glb` + texturas + `.import` versionados. Verificar abriendo una copia. |
