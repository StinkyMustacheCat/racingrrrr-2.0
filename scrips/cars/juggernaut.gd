extends CharacterBody3D
#Juggernaut
@export var acceleration: float = 12.0  
@export var max_speed: float = 25.0  
@export var max_reverse_speed: float = 6.0  
@export var friction: float = 6.0  
@export var brake_force: float = 3.0  
@export var normal_turn_speed: float = 3  
@export var gravity: float = -40.0  
@export var fall_multiplier: float = 2.0  
@export var turn_speed_multiplier: float = 1.2  
@export var handbrake_friction: float = 4.0  
@export var handbrake_turn_boost: float = 2.0  
@export var handbrake_speed_reduction: float = 0.97  
@export var drift_inertia: float = 0.9  
@export var stability_control: float = 0.15  
@export var high_speed_turn_reduction: float = 0.8  
@export var air_turn_speed_factor: float = 0.5  # Nuevo parámetro para control en el aire (más bajo que el del Tempest)

var velocity_forward: float = 0.0  
var handbrake_active: bool = false  
var drift_vector: Vector3 = Vector3.ZERO

func _physics_process(delta):
	var on_ground = is_on_floor()
	var is_accelerating = Input.is_action_pressed("accelerate")
	var is_reversing = Input.is_action_pressed("reverse")
	handbrake_active = Input.is_action_pressed("handbrake") and on_ground  # Solo se activa si está en el suelo

	var input_direction: int = 0 if handbrake_active else (1 if is_accelerating else -1 if is_reversing else 0)

	# Frenado progresivo solo si está en el suelo
	if on_ground:
		if (input_direction == -1 and velocity_forward > 0) or (input_direction == 1 and velocity_forward < 0):
			velocity_forward = move_toward(velocity_forward, 0.0, brake_force * delta)
		else:
			if input_direction != 0:
				var target_speed: float = max_speed if input_direction > 0 else -max_reverse_speed
				velocity_forward = move_toward(velocity_forward, target_speed, acceleration * delta)
			else:
				var applied_friction: float = handbrake_friction if handbrake_active else friction
				velocity_forward = move_toward(velocity_forward, 0.0, applied_friction * delta)

		if handbrake_active:
			velocity_forward *= handbrake_speed_reduction

	# Reducción del giro con la velocidad
	var speed_factor = abs(velocity_forward) / max_speed  
	var turn_reduction = 1.0 / (1.0 + (speed_factor * high_speed_turn_reduction * 5.0))  
	turn_reduction = clamp(turn_reduction, 0.0 if velocity_forward == 0 else 0.3, 1.0)  

	# Boost de giro con freno de mano
	var handbrake_turn_multiplier = handbrake_turn_boost if handbrake_active else 1.0
	var turn_speed_actual = normal_turn_speed * turn_speed_multiplier * turn_reduction * handbrake_turn_multiplier

	# Solo permite girar si está en el suelo
	if velocity_forward != 0 and on_ground:
		if Input.is_action_pressed("turn_left"):
			rotation.y += turn_speed_actual * delta  
		if Input.is_action_pressed("turn_right"):
			rotation.y -= turn_speed_actual * delta  

	# Mantener inercia en los derrapes
	var move_direction: Vector3 = Vector3.FORWARD.rotated(Vector3.UP, rotation.y) * velocity_forward
	drift_vector = drift_vector.slerp(move_direction, drift_inertia)
	velocity = Vector3(drift_vector.x, velocity.y, drift_vector.z)

	# Control de estabilidad
	var normalized_move_direction = move_direction.normalized()
	var normalized_drift_vector = drift_vector.normalized()
	var angle_diff = normalized_move_direction.signed_angle_to(normalized_drift_vector, Vector3.UP)

	if abs(angle_diff) > stability_control:
		rotation.y -= angle_diff * stability_control * delta

	# Aplicar gravedad cuando está en el aire
	if !on_ground:
		velocity.y += gravity * fall_multiplier * delta
		
		# Control de giro en el aire (menos intenso para el Juggernaut)
		var air_turn_speed = normal_turn_speed * air_turn_speed_factor  # Ajuste menor para el Juggernaut
		if Input.is_action_pressed("turn_left"):
			rotation.y += air_turn_speed * delta
		if Input.is_action_pressed("turn_right"):
			rotation.y -= air_turn_speed * delta

	move_and_slide()
