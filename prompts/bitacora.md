# Bitácora de generación del modelo

Registro de trazabilidad (prompt, herramienta, fecha, ajustes, procedencia,
correcciones). Dos generaciones realizadas con **Tripo**.

## Entrada 1 — Variante humano low-poly

| Campo | Valor |
|-------|-------|
| Fecha | 7 de octubre de 2026 |
| Herramienta | Tripo (Text/Image to 3D) |
| Prompt exacto | ⟶ COMPLETAR si difiere del sugerido en `prompt_modelo.md` |
| Ajustes | Salida GLB, PBR, simetría activada, pose A/T |
| ID de generación | ⟶ COMPLETAR (si Tripo lo muestra en el historial) |
| Resultado | OK (descartado como final por tener menos detalle/texturas) |
| Procedencia / licencia | Tripo — ⟶ COMPLETAR URL del proyecto |
| Archivo | `assets/models/character_ai_dev.glb` (~9.208 tris) |
| Correcciones aplicadas | Escala 1.8 para llevar de ~1.0 m a ~1.8 m |

## Entrada 2 — Personaje bíblico (FINAL)

| Campo | Valor |
|-------|-------|
| Fecha | 7 de octubre de 2026 |
| Herramienta | Tripo (Text/Image to 3D) — confirmado por nombres internos `tripo_node_*`, `tripo_image_*` |
| Prompt exacto | ⟶ COMPLETAR (pega el texto literal usado en Tripo) |
| Ajustes | Salida GLB con texturas externas (albedo .jpg, metallic/roughness .png), PBR |
| ID de generación | 76a15f12-5168-4c38-bfe2-9bfc7c68365a (visible en los nombres de textura) |
| Resultado | OK — elegido como modelo final |
| Procedencia / licencia | Tripo — ⟶ COMPLETAR URL del proyecto |
| Archivo | `assets/models/biblical+character+3d+model.glb` (~80.065 tris) |
| Correcciones aplicadas | Escala 1.84 para llevar de ~0.98 m a ~1.8 m; movido a `assets/models/` |

## Notas de importación en Godot

- Escala final aplicada: 1.84 en `scenes/character_model.tscn` (nodo `AIModel`).
- Problemas encontrados al importar: ninguno; importación de escena completada
  sin errores (104 pasos). Los pies ya quedaban en y=0, no hubo que recentrar.
- Cómo se resolvieron: solo se ajustó la escala para igualar la cápsula del
  jugador (altura 1.8). El modelo quedó aislado en la escena envolvente, sin
  tocar el controlador.
