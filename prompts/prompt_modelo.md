# Prompt exacto para generar el modelo (Tripo / Meshy)

> Copia este texto en el campo *Text to 3D* del generador. Ajusta nombre/estilo
> a tu gusto, pero mantén un personaje **simple** (requisito del enunciado) y en
> **T-pose o A-pose** para facilitar el rig de la Tarea 2.

## Prompt principal (inglés — mejor soporte en los generadores)

```
A simple stylized low-poly humanoid game character, full body, standing in
A-pose, facing forward. Clean topology, clearly separated limbs (arms, legs,
head, torso) suitable for rigging. Flat PBR materials, soft colors, no text,
no logos. Neutral proportions, around 1.8 meters tall. Single mesh, game-ready,
clean normals.
```

## Prompt alterno (variante para comparación — paso 5 del enunciado)

```
A simple stylized low-poly robot character, full body, standing in A-pose,
facing forward, blocky limbs, metallic PBR material, clean topology,
game-ready, clean normals, ~1.8 m tall.
```

## Ajustes recomendados en el generador

- **Formato de salida:** glb (incluye materiales y texturas en un archivo).
- **Topología:** "quad / low-poly" si está disponible.
- **PBR:** activado (albedo + normal + roughness).
- **Symmetry:** activada (personaje simétrico).
- **Pose:** A-pose o T-pose.

## Tras generar

1. Descarga el `.glb`.
2. Guárdalo en `assets/models/`.
3. Rellena `prompts/bitacora.md` y `docs/ficha_modelo.md`.
4. Haz la comparación en `prompts/comparacion_antes_despues.md`.

> Si el acceso al generador no es posible, usa un recurso de práctica autorizado
> (p. ej. Kenney, Mixamo, Quaternius — con licencia libre) y **declara su
> origen** en la bitácora, evaluando las mismas verificaciones de la ficha.
