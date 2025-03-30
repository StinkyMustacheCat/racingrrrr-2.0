extends Camera3D

@export var vehicle: Node3D  # Referencia al vehículo
@export var tilt_amount: float = 5.0  # Máxima inclinación en grados
@export var tilt_speed: float = 5.0  # Velocidad de interpolación
@export var follow_speed: float = 8.0  # Velocidad de seguimiento del auto

var initial_offset: Vector3  # Posición inicial relativa al vehículo

func _ready():
	if vehicle:
		initial_offset = global_transform.origin - vehicle.global_transform.origin  # Calcula el offset inicial

func _process(delta):
	if vehicle:
		# Suaviza la posición de la cámara siguiendo al auto
		var target_position = vehicle.global_transform.origin + initial_offset
		global_transform.origin = global_transform.origin.lerp(target_position, follow_speed * delta)
		
		# Calcula la inclinación según la rotación en Y del vehículo
		var target_tilt = -vehicle.rotation.y * tilt_amount
		rotation_degrees.z = lerp(rotation_degrees.z, target_tilt, tilt_speed * delta)
