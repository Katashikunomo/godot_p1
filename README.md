# Tarea 1 — Escena base y modelo generado con IA (Godot 4.x)

Escena 3D controlable en Godot con `CharacterBody3D`, movimiento relativo a la
cámara, cámara en tercera persona con `SpringArm3D`, una máquina de estados
finitos (Idle / Walk / Jump) y una escena envolvente lista para integrar un
modelo generado con IA (Tripo / Meshy).

## Versión del motor

- **Godot 4.7.2 stable** (Forward+). Compatible con cualquier Godot 4.x reciente.

## Cómo abrir y ejecutar

1. Abrir **Godot 4.7.2**.
2. `Import` → seleccionar `project.godot` de esta carpeta.
3. Pulsar **F5** (o el botón ▶) para ejecutar. La escena principal es
   `scenes/level.tscn`.

Desde línea de comandos (Windows):

```powershell
& "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.7.2-stable_win64.exe" --path .
```

## Controles

| Acción            | Tecla / Entrada            |
|-------------------|----------------------------|
| Mover             | `W A S D` o flechas        |
| Saltar            | `Espacio` (solo en suelo)  |
| Girar cámara      | Mover el ratón             |
| Liberar el ratón  | `Esc`                      |

El movimiento es **relativo a la cámara**: "adelante" siempre es hacia donde
mira la cámara.

## Estructura de carpetas

```
UAM/
├─ project.godot            # Config del proyecto + mapa de inputs
├─ icon.svg
├─ scenes/
│  ├─ level.tscn            # Nivel: entorno, luz, suelo y obstáculos
│  ├─ player.tscn           # Personaje: cuerpo + cámara + UI de estado
│  └─ character_model.tscn  # Escena ENVOLVENTE del modelo (placeholder/IA)
├─ scripts/
│  ├─ player.gd             # Controlador + FSM (lógica propia, NO delegada)
│  └─ camera_rig.gd         # Rig de cámara con SpringArm3D
├─ assets/
│  └─ models/               # Aquí va el .glb generado con IA
├─ docs/
│  ├─ plan_ai_dlc.md        # Plan siguiendo metodología AI-DLC
│  ├─ documento_entrega.md  # Base del PDF de 4–6 páginas
│  └─ ficha_modelo.md       # Ficha de triángulos/materiales/escala/procedencia
└─ prompts/
   ├─ prompt_modelo.md      # Prompt exacto usado en Tripo/Meshy
   ├─ bitacora.md           # Fecha, herramienta, ajustes, procedencia
   └─ comparacion_antes_despues.md
```

## Arquitectura de escenas

- `level.tscn` instancia `player.tscn`.
- `player.tscn` instancia `character_model.tscn` dentro de `ModelRoot`.
  Esta separación mantiene el **modelo importado independiente del
  controlador**: cambiar el modelo no toca la lógica.

```
Level (Node3D)
├─ WorldEnvironment        # Cielo procedural + ambiente
├─ DirectionalLight3D      # Luz direccional con sombras
├─ Floor (StaticBody3D)    # Suelo con CollisionShape3D
├─ WallA / WallB (StaticBody3D)
├─ CrateA / CrateB / CrateC (StaticBody3D)
├─ Player (CharacterBody3D)        → scripts/player.gd
│  ├─ Collision (CapsuleShape3D)
│  ├─ ModelRoot
│  │  └─ CharacterModel (instancia de character_model.tscn)
│  ├─ CameraPivot (Node3D)         → scripts/camera_rig.gd
│  │  └─ SpringArm3D
│  │     └─ Camera3D
│  └─ DebugUI → StateLabel         # muestra el estado activo de la FSM
└─ HUD → Help                      # instrucciones en pantalla
```

## Tratamiento del tiempo (delta)

- La **gravedad** es una aceleración (m/s²) e integra la velocidad:
  `velocity.y -= gravity * delta`.
- `SPEED` y `JUMP_VELOCITY` son velocidades objetivo (m/s). **No** se
  multiplican por `delta`; `move_and_slide()` integra la posición con el delta
  de física interno, evitando aplicar el tiempo dos veces.
- La física vive en `_physics_process(delta)` (paso fijo). La presentación
  (texto de estado, giro visual del modelo) vive en `_process(delta)`.

## FSM (Idle / Walk / Jump)

- `IDLE`: en el suelo, sin dirección de entrada.
- `WALK`: en el suelo, con dirección de entrada.
- `JUMP`: fuera del suelo (subiendo o cayendo).
- Transiciones explícitas en `_update_state()`; cada entrada de estado llama a
  `_on_state_entered()` (punto de enganche para los clips de animación de la
  Tarea 2) e imprime la transición en consola.

## Integración del modelo IA

El modelo generado con Tripo/Meshy se exporta como `.glb`, se coloca en
`assets/models/` y se **arrastra como hijo de `ModelRoot`** dentro de
`character_model.tscn`, sustituyendo el placeholder (cápsula + esfera). El
controlador no cambia. Ver `docs/ficha_modelo.md` y la carpeta `prompts/`.

> Nota: el placeholder incluido permite probar toda la lógica (movimiento,
> cámara, FSM) sin bloquear el avance mientras se genera el modelo real.
