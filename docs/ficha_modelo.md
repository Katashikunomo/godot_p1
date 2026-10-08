# Ficha del modelo generado con IA

> Datos técnicos medidos directamente sobre el `.glb` importado en Godot 4.7.2.
> El modelo final es el "bíblico" (más detallado y con texturas PBR). El modelo
> humano low-poly anterior se conserva como variante para la comparación
> antes/después.

## Modelo FINAL (en uso)

| Campo | Valor |
|-------|-------|
| Nombre | Biblical character |
| Archivo | `assets/models/biblical+character+3d+model.glb` |
| Herramienta | **Tripo** (confirmado por nombres `tripo_node_*` / `tripo_image_*`) |
| Fecha de generación | ⟶ COMPLETAR |
| Formato exportado | `.glb` + texturas externas (.jpg albedo, .png metallic/roughness) |
| Triángulos | ~80.065 |
| Superficies / materiales | 1 superficie → 1 material PBR con textura albedo |
| Texturas | Albedo (.jpg) + Metallic-Roughness (.png) |
| Esqueleto / articulaciones | No tiene (modelo estático; rig y animación en Tarea 2) |
| Altura original | ~0.98 m (AABB Y = 0.9776) |
| Escala aplicada en escena | 1.84 → altura final ~1.8 m |
| Pivote / origen | Pies en y = 0 (AABB.position.y = 0.0), centrado en X/Z |
| Dimensiones (orig.) | Alto 0.98 · Ancho 0.97 · Profundidad 0.23 (m) |
| Procedencia | ⟶ COMPLETAR (URL del proyecto en Tripo / licencia) |

> **Nota de rendimiento:** 80k triángulos es alto para un personaje de juego
> (lo típico ronda 5k–20k). Para esta tarea funciona sin problema; si se buscara
> optimizar, Tripo ofrece una opción de reducción de polígonos (decimate) al
> exportar.

## Modelo VARIANTE (conservado para comparación)

| Campo | Valor |
|-------|-------|
| Archivo | `assets/models/character_ai_dev.glb` |
| Triángulos | ~9.208 |
| Materiales | 1 (sin texturas externas detectadas) |
| Altura original | ~1.00 m |
| Uso | Primera generación; sirve para la comparación antes/después |

## Checklist de revisión (del enunciado) — modelo final

- [x] **Malla:** importa con 1 superficie y ~80k triángulos; geometría válida.
- [x] **Escala:** altura original 0.98 m corregida a ~1.8 m (escala 1.84),
      coherente con la cápsula del jugador (altura 1.8).
- [ ] **Normales:** ⟶ verifica en el editor que la iluminación es coherente al
      girar la luz (sin caras oscuras invertidas).
- [x] **Materiales:** material PBR con textura albedo detectado y asignado.
- [x] **Articulaciones:** sin esqueleto; apropiado para Tarea 1.

## Integración realizada

- Modelo final movido a `assets/models/` e importado por Godot (uid
  `cqvnaoti4f44k`), con sus texturas externas.
- En `scenes/character_model.tscn` se instancia como nodo `AIModel` con escala
  1.84. El placeholder fue eliminado.
- El controlador (`player.gd`) y la escena del jugador NO se tocaron: el modelo
  queda aislado dentro de la escena envolvente.
- Verificado en headless: carga y ejecuta sin errores; la FSM reporta
  transiciones correctamente.
