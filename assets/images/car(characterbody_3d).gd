extends CharacterBody3D

# Variables exportadas para el control del movimiento
@export var acceleration = 0.3  
@export var max_speed = 40  
@export var friction = 5.0  
@export var normal_turn_speed = 2.0  
@export var air_turn_speed = 0.5  
@export var gravity = -30.0  
@export var fall_multiplier = 2.5  
@export var speedometer: ProgressBar  # ProgressBar para mostrar la velocidad

func _physics_process(delta):
	# Determina la velocidad de rotación en función de si el personaje está en impulso o no
	var turn_speed = normal_turn_speed
	var input_direction = Vector3.ZERO

	if is_on_floor():
		input_direction = handle_ground_movement(delta, turn_speed)
	else:
		handle_air_movement(delta)

	update_velocity(delta)
	update_speedometer()
	move_and_slide()
# Maneja el movimiento cuando el personaje está en el suelo
func handle_ground_movement(delta, turn_speed):
	var direction = Vector3.ZERO
	# Procesa las entradas de movimiento
	if Input.is_action_pressed("accelerate"):
		direction.z -= 1  # Avanzar
	if Input.is_action_pressed("brake"):
		direction.z += 1  # Frenar
	# Procesa las entradas de giro
	if Input.is_action_pressed("turn_left"):
		rotation.y += turn_speed * delta
	if Input.is_action_pressed("turn_right"):
		rotation.y -= turn_speed * delta

	direction = direction.rotated(Vector3.UP, rotation.y)  # Rota la dirección de entrada
	# Aplica el movimiento con la velocidad y aceleración correspondientes
	if direction != Vector3.ZERO:
		velocity = velocity.lerp(direction * max_speed, acceleration * delta)
	else:
		velocity = velocity.lerp(Vector3.ZERO, friction * delta)
	return direction
# Maneja el movimiento cuando el personaje está en el aire
func handle_air_movement(delta):
	if Input.is_action_pressed("turn_left"):
		rotation.y += air_turn_speed * delta
	if Input.is_action_pressed("turn_right"):
		rotation.y -= air_turn_speed * delta
# Actualiza la velocidad del personaje teniendo en cuenta la gravedad
func update_velocity(delta):
	if not is_on_floor():
		if velocity.y > 0:
			velocity.y += gravity * delta * fall_multiplier
		else:
			velocity.y += gravity * delta * fall_multiplier
# Actualiza el valor del speedometer con la velocidad actual
func update_speedometer():
	if speedometer:
		var speed = velocity.length()  # Calcula la longitud de la velocidad
		var speed_ratio = speed / max_speed  # Relaciona la velocidad con la velocidad máxima
		speedometer.value = speed_ratio * speedometer.max_value  # Actualiza el progress bar
