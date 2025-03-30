extends Camera3D

@export var tilt_amount: float = 8.0  # Inclinación de la cámara en giros
@export var tilt_speed: float = 3.0  # Suavidad de la interpolación
@export var yaw_amount: float = 10.0  # Pequeño giro en Y para enfatizar los giros
@export var yaw_speed: float = 3.0  # Suavidad de interpolación del yaw

var target_tilt: float = 0.0
var target_yaw: float = 0.0

func _process(delta):
	var car = get_parent()  # Se asume que la cámara es hija del auto
	if car == null:
		return

	var speed_factor = abs(car.velocity_forward) / car.max_speed
	var turning = 0

	if Input.is_action_pressed("turn_left"):
		turning = -1
	elif Input.is_action_pressed("turn_right"):
		turning = 1

	# Inclinación de la cámara al girar
	target_tilt = tilt_amount * turning * speed_factor
	rotation_degrees.z = lerp(rotation_degrees.z, target_tilt, tilt_speed * delta)

	# Pequeño giro en Y para enfatizar la sensación de giro
	target_yaw = yaw_amount * turning * speed_factor
	rotation_degrees.y = lerp(rotation_degrees.y, target_yaw, yaw_speed * delta)
