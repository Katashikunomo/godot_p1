extends Node3D
## Rig de camara en tercera persona.
##
## Estructura esperada en el arbol:
##   CameraPivot (este nodo)   -> gira en yaw (horizontal) y pitch (vertical)
##     └─ SpringArm3D          -> empuja la camara hacia el pivot si choca con paredes
##          └─ Camera3D
##
## El SpringArm3D es la solucion NATIVA de Godot para evitar que la camara
## atraviese paredes: lanza un rayo/forma desde el pivot y acorta su longitud
## cuando detecta colision, manteniendo al personaje siempre visible.

const MOUSE_SENSITIVITY: float = 0.0025
const PITCH_MIN: float = deg_to_rad(-60.0)
const PITCH_MAX: float = deg_to_rad(70.0)

var _yaw: float = 0.0
var _pitch: float = deg_to_rad(-15.0)

@onready var spring_arm: SpringArm3D = $SpringArm3D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# El SpringArm NO debe colisionar con el propio jugador (padre del rig).
	var player := get_parent()
	if player is CollisionObject3D:
		spring_arm.add_excluded_object(player.get_rid())
	_apply_rotation()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_yaw -= event.relative.x * MOUSE_SENSITIVITY
		_pitch -= event.relative.y * MOUSE_SENSITIVITY
		_pitch = clampf(_pitch, PITCH_MIN, PITCH_MAX)
		_apply_rotation()

	# Alternar captura del raton (tecla configurada: toggle_mouse / ESC).
	if event.is_action_pressed("toggle_mouse"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _apply_rotation() -> void:
	rotation = Vector3(_pitch, _yaw, 0.0)
