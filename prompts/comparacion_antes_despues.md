# Comparación antes / después

Se generaron **dos variantes** del personaje con IA. Esta sección compara ambas
y justifica la elección de la final. Los datos técnicos se midieron sobre los
`.glb` importados en Godot 4.7.2.

## Comparación de variantes

| Aspecto | Variante 1 (humano low-poly) | Variante 2 — FINAL (bíblico) | Diferencia |
|---------|------------------------------|------------------------------|------------|
| Archivo | `character_ai_dev.glb` | `biblical+character+3d+model.glb` | — |
| Triángulos | ~9.208 | ~80.065 | La final tiene ~8.7× más detalle |
| Materiales | 1 (sin texturas externas) | 1 PBR con textura albedo | La final tiene materiales PBR reales |
| Texturas | No detectadas | Albedo (.jpg) + Metallic/Roughness (.png) | La final aporta texturizado completo |
| Altura original | ~1.00 m | ~0.98 m | Casi igual |
| Escala aplicada | 1.8 → ~1.8 m | 1.84 → ~1.8 m | Ambas normalizadas a 1.8 m |
| Pivote | Pies en y=0, centrado | Pies en y=0, centrado | Igual, correcto |
| Esqueleto | No | No | Igual (estáticos, rig en Tarea 2) |

## Captura antes / después

- Antes (Variante 1): ⟶ COMPLETAR (captura del humano low-poly en escena)
- Después (Variante 2): ⟶ COMPLETAR (captura del modelo bíblico texturizado)

## Qué cambió y por qué se eligió la final

Se eligió la **Variante 2 (bíblico)** como modelo final porque incorpora
**materiales PBR con texturas** (albedo + metallic/roughness), lo que da un
acabado visual más completo tras la importación, mientras que la Variante 1 solo
tenía color plano sin texturas enlazadas. Ambas requirieron la **misma
corrección de escala** (el generador exporta a ~1 m de alto, por lo que se
aplicó un factor ~1.8 en la escena envolvente para igualar la cápsula del
jugador de 1.8 m de altura).

Contrapartida registrada: la Variante 2 es mucho más pesada en geometría
(~80k vs ~9k triángulos). Para esta tarea es aceptable; para un juego real
convendría reducir polígonos.

## Verificaciones adicionales (las tres exigidas)

1. **Escala:** altura final ~1.8 m, coherente con la cápsula de colisión
   (`CapsuleShape3D` altura 1.8). Evidencia: ficha del modelo + captura en escena.
2. **Normales / iluminación:** ⟶ confirmar en el editor que la luz direccional
   ilumina al personaje sin caras oscuras invertidas al girarlo.
3. **Materiales / texturas:** material PBR con textura albedo detectado y
   asignado tras importar (`albedo_tex=true` al inspeccionar la malla).
