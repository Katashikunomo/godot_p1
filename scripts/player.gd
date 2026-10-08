extends CharacterBody3D
## Controlador del personaje.
##
## Responsabilidades:
##  - Movimiento horizontal RELATIVO A LA CAMARA.
##  - Gravedad y salto (salto solo cuando el cuerpo esta en el suelo).
##  - FSM explicita con estados IDLE / WALK / JUMP.
##
## Separacion fisica vs visual:
##  - _physics_process(delta): TODA la fisica (velocity, move_and_slide, gravedad,
##    salto, deteccion de estado). Se ejecuta a paso fijo (Physics Ticks/seg).
##  - _process(delta): SOLO presentacion (texto de estado en pantalla, rotacion
##    visual del malla). No modifica velocity ni posicion fisica.
##
## Uso de delta (importante para la evaluacion):
##  - La gravedad es una ACELERACION (m/s^2): se integra como v += g * delta.
##  - La velocidad ya es (m/s); move_and_slide() integra posicion con su propio
##    delta de fisica internamente, por eso NO multiplicamos la velocidad por
##    delta otra vez (evitar aplicar el tiempo dos veces a la misma magnitud).
##  - SPEED y JUMP_VELOCITY son velocidades objetivo (m/s), no se escalan por delta.

enum State { IDLE, WALK, JUMP }

const SPEED: float = 5.0            # m/s  -> velocidad objetivo horizontal
const JUMP_VELOCITY: float = 5.0    # m/s  -> impulso vertical inicial del salto
const ACCEL: float = 12.0           # 1/s  -> suavizado de aceleracion (lerp por delta)
const ROTATION_SPEED: float = 10.0  # 1/s  -> suavizado del giro visual del modelo

# Gravedad tomada del proyecto para coherencia fisica.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)

var current_state: State = State.IDLE
var previous_state: State = State.IDLE

@onready var camera_pivot: Node3D = $CameraPivot
@onready var model_root: Node3D = $ModelRoot          # escena envolvente del modelo IA
@onready var state_label: Label = get_node_or_null("DebugUI/StateLabel")


func _physics_process(delta: float) -> void:
	# --- 1) Gravedad: aceleracion integrada en el tiempo ---
	if not is_on_floor():
		velocity.y -= gravity * delta  # delta aqui es correcto: g es m/s^2

	# --- 2) Salto: solo cuando corresponde (en el suelo) ---
	var wants_jump := Input.is_action_just_pressed("jump") and is_on_floor()
	if wants_jump:
		velocity.y = JUMP_VELOCITY     # velocidad objetivo, NO escalar por delta

	# --- 3) Direccion de entrada relativa a la camara ---
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := _camera_relative_direction(input_dir)

	# --- 4) Velocidad horizontal con suavizado dependiente de delta ---
	var target_h := direction * SPEED
	# lerp con factor dependiente de delta: respuesta estable ante distintos FPS.
	var t := clampf(ACCEL * delta, 0.0, 1.0)
	velocity.x = lerpf(velocity.x, target_h.x, t)
	velocity.z = lerpf(velocity.z, target_h.z, t)

	# --- 5) Mover el cuerpo (integra posicion con el delta de fisica interno) ---
	move_and_slide()

	# --- 6) Orientar el modelo hacia el movimiento (visual, suave) ---
	if direction.length() > 0.1:
		var target_yaw := atan2(direction.x, direction.z)
		model_root.rotation.y = lerp_angle(model_root.rotation.y, target_yaw, clampf(ROTATION_SPEED * delta, 0.0, 1.0))

	# --- 7) FSM: calcular transiciones a partir del estado fisico ---
	_update_state(direction, wants_jump)


## Convierte la entrada 2D en una direccion 3D en el plano XZ,
## alineada con el yaw de la camara (movimiento relativo a camara).
func _camera_relative_direction(input_dir: Vector2) -> Vector3:
	if input_dir == Vector2.ZERO:
		return Vector3.ZERO
	var cam_yaw := camera_pivot.global_rotation.y
	var basis := Basis(Vector3.UP, cam_yaw)
	# input_dir.y positivo = atras (move_back), por eso el eje Z usa input_dir.y.
	var dir := basis * Vector3(input_dir.x, 0.0, input_dir.y)
	return dir.normalized()


## Maquina de estados finitos con transiciones EXPLICITAS.
func _update_state(direction: Vector3, _wants_jump: bool) -> void:
	var next_state := current_state

	if not is_on_floor():
		# En el aire siempre estamos en JUMP (subiendo o cayendo).
		next_state = State.JUMP
	else:
		# En el suelo: WALK si hay direccion, IDLE si no.
		if direction.length() > 0.1:
			next_state = State.WALK
		else:
			next_state = State.IDLE

	if next_state != current_state:
		previous_state = current_state
		current_state = next_state
		_on_state_entered(current_state)


## Hook llamado al ENTRAR en un estado (punto de enganche para animaciones en Tarea 2).
func _on_state_entered(state: State) -> void:
	# En Tarea 2 aqui se dispara el clip de animacion correspondiente.
	print("[FSM] %s -> %s" % [State.keys()[previous_state], State.keys()[current_state]])


func _process(_delta: float) -> void:
	# SOLO presentacion: actualizar el indicador de estado en pantalla.
	if state_label:
		var floor_txt := "SUELO" if is_on_floor() else "AIRE"
		state_label.text = "Estado: %s\n(%s)  vel=(%.1f, %.1f, %.1f)" % [
			State.keys()[current_state], floor_txt,
			velocity.x, velocity.y, velocity.z
		]
