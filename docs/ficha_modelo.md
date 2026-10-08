# Ficha del modelo generado con IA

> Rellena tras generar e importar el `.glb`. Puedes leer los datos exactos en
> Godot: selecciona el nodo del modelo importado y en *Import* / inspector
> encontrarás materiales y texturas; para el conteo de triángulos usa el panel
> inferior derecho de la vista 3D (información de rendimiento) o el inspector
> del `MeshInstance3D`.

| Campo | Valor |
|-------|-------|
| Nombre del personaje | ⟶ COMPLETAR |
| Herramienta | ⟶ COMPLETAR (Tripo / Meshy) |
| Fecha de generación | ⟶ COMPLETAR |
| Formato exportado | `.glb` (recomendado) |
| Triángulos | ⟶ COMPLETAR |
| Vértices | ⟶ COMPLETAR |
| Materiales | ⟶ COMPLETAR (nº y nombres) |
| Texturas | ⟶ COMPLETAR (albedo / normal / roughness, resolución) |
| Escala en escena | ~1.8 m de alto (ajustar en `character_model.tscn`) |
| Pivote / origen | A los pies, mirando a +Z |
| Procedencia | ⟶ COMPLETAR (URL del generador / licencia / autor) |

## Checklist de revisión (del enunciado)

- [ ] **Malla:** sin huecos ni caras invertidas visibles.
- [ ] **Escala:** altura coherente (~1.8 m) respecto a la cápsula del jugador.
- [ ] **Normales:** iluminación correcta, sin caras oscuras invertidas.
- [ ] **Materiales:** asignados y visibles; texturas enlazadas.
- [ ] **Articulaciones:** si trae esqueleto, los huesos tienen nombres y jerarquía
      razonables (la animación esquelética se trabaja en Tarea 2).

## Pasos de integración

1. Copiar el `.glb` (y sus texturas) a `assets/models/`.
2. Dejar que Godot lo importe (genera `.import`).
3. Abrir `scenes/character_model.tscn`.
4. Arrastrar el `.glb` como hijo del nodo raíz `CharacterModel`.
5. Ajustar `scale` y posición para que los pies queden en `y = 0` y la altura
   coincida con la cápsula (radio 0.4, altura 1.8).
6. Eliminar los nodos placeholder (`PlaceholderBody`, `PlaceholderHead`,
   `FrontMarker`).
7. Guardar. El controlador no requiere cambios.
