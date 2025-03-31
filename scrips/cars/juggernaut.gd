extends CharacterBody3D

# Variables de ajuste
@export var acceleration: float = 12.0  
@export var max_speed: float = 25.0  
@export var max_reverse_speed: float = 8.0  
@export var friction: float = 6.0  
@export var brake_force: float = 3.0  
@export var normal_turn_speed: float = 3.0  
@export var gravity: float = -40.0  
@export var fall_multiplier: float = 2.0 
@export var turn_speed_multiplier: float = 1.2  
@export var handbrake_friction: float = 4.0 
@export var handbrake_turn_boost: float = 2 
@export var handbrake_speed_reduction: float = 0.97 
@export var drift_inertia: float = 0.9 
@export var stability_control: float = 0.9  
@export var high_speed_turn_reduction: float = 0.8  
@export var air_turn_speed_factor: float = 0.01 

var velocity_forward: float = 0.0  
var handbrake_active: bool = false  
var drift_vector: Vector3 = Vector3.ZERO
var previous_rotation_y: float = 0.0  
var angular_velocity: float = 0.0  

var raycast: RayCast3D  

func _ready():
	raycast = $RayCast3D

func _physics_process(delta):
	var is_accelerating = Input.is_action_pressed("accelerate")
	var is_reversing = Input.is_action_pressed("reverse")
	handbrake_active = Input.is_action_pressed("handbrake")

	var input_direction: int = 0 if handbrake_active else (1 if is_accelerating else -1 if is_reversing else 0)

	# Frenado progresivo
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
		drift_vector = drift_vector.slerp(Vector3.ZERO, 0.1)  

	var speed_factor = abs(velocity_forward) / max_speed  
	var turn_reduction = 1.0 / (1.0 + (speed_factor * high_speed_turn_reduction * 5.0))  
	turn_reduction = clamp(turn_reduction, 0.0 if velocity_forward == 0 else 0.3, 1.0)  

	var handbrake_turn_multiplier = handbrake_turn_boost if handbrake_active else 1.0
	var turn_speed_actual = normal_turn_speed * turn_speed_multiplier * turn_reduction * handbrake_turn_multiplier  

	if velocity_forward != 0:
		if Input.is_action_pressed("turn_left"):
			rotation.y += turn_speed_actual * delta  
		if Input.is_action_pressed("turn_right"):
			rotation.y -= turn_speed_actual * delta  

	var move_direction: Vector3 = Vector3.FORWARD.rotated(Vector3.UP, rotation.y) * velocity_forward
	drift_vector = drift_vector.slerp(move_direction, drift_inertia)
	velocity = Vector3(drift_vector.x, velocity.y, drift_vector.z)

	var normalized_move_direction = move_direction.normalized()
	var normalized_drift_vector = drift_vector.normalized()

	var angle_diff = normalized_move_direction.signed_angle_to(normalized_drift_vector, Vector3.UP)
	if abs(angle_diff) > stability_control:
		rotation.y -= angle_diff * stability_control * delta

	if !is_on_floor():
		var air_turn_speed = normal_turn_speed * air_turn_speed_factor  
		if Input.is_action_pressed("turn_left"):
			rotation.y += air_turn_speed * delta
		if Input.is_action_pressed("turn_right"):
			rotation.y -= air_turn_speed * delta

	if !is_on_floor():
		velocity.y += gravity * fall_multiplier * delta

	if raycast.is_colliding():
		var normal = raycast.get_collision_normal()
		var angle = normal.angle_to(Vector3.UP)
		print("Pendiente detectada con ángulo: ", angle)

		if angle == 0:
			max_speed = 25.0  
		elif angle < 0.056:
			max_speed = 24.0  
		elif angle < 0.19:
			max_speed = 23.0  
		print("Velocidad máxima ajustada a: ", max_speed)

		# Reversa por gravedad

		if angle > 0.05 and abs(velocity_forward) < 1.0 and !is_accelerating and !is_reversing:
			var gravity_reverse_force = sin(angle) * max_reverse_speed * 6.0  # Aumentamos aún más la fuerza
			velocity_forward -= gravity_reverse_force * delta  # Aplicamos la fuerza directamente
			velocity_forward = clamp(velocity_forward, -max_reverse_speed, 0)  # Evitar que supere la reversa máxima
			print("Aplicando reversa por gravedad: ", velocity_forward)



	else:
		max_speed = 25.0  

	move_and_slide()

	angular_velocity = (rotation.y - previous_rotation_y) / delta
	previous_rotation_y = rotation.y
