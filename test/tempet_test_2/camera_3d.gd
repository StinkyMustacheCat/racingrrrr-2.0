extends Camera3D

@export var target: CharacterBody3D  # El auto a seguir
@export var follow_speed: float = 5.0  # Suavizado del seguimiento
@export var min_distance: float = 3.0  # Distancia mínima de la cámara
@export var max_distance: float = 6.0  # Distancia máxima de la cámara
@export var height: float = 2.0  # Altura de la cámara
@export var zoom_speed: float = 5.0  # Velocidad de ajuste del zoom
@export var rotation_speed: float = 3.0  # Velocidad de rotación de la cámara alrededor del coche
@export var drift_offset: float = 0.5  # Desplazamiento de la cámara para simular el derrape (ajustado)
@export var drift_smoothness: float = 0.1  # Suavizado del derrape (ajustado)
@export var max_angular_velocity: float = 5.0  # Límite para la velocidad angular del derrape

var current_drift_amount: Vector3 = Vector3.ZERO  # Almacena el desplazamiento actual del derrape

func _process(delta):
	if target:
		# Calcular distancia de la cámara en base a la velocidad
		var speed_factor = target.velocity.length() / target.max_speed
		var dynamic_distance = lerp(min_distance, max_distance, speed_factor)

		# Posición deseada de la cámara detrás del coche
		var target_position = target.global_transform.origin
		var desired_position = target_position + target.global_transform.basis.z * dynamic_distance
		desired_position.y += height

		# Calcular el desplazamiento del derrape basado en la velocidad angular
		# Asegurarnos de que la velocidad angular se mantenga en un rango razonable
		var angular_velocity = target.angular_velocity
		if abs(angular_velocity) > max_angular_velocity:
			angular_velocity = sign(angular_velocity) * max_angular_velocity  # Limitar la velocidad angular

		var target_drift_amount = target.global_transform.basis.x * angular_velocity * drift_offset

		# Suavizar el desplazamiento del derrape
		current_drift_amount = current_drift_amount.lerp(target_drift_amount, drift_smoothness)

		# Aplicar el desplazamiento del derrape a la posición deseada
		desired_position += current_drift_amount

		# Detección de colisiones para ajustar la distancia durante saltos
		var ray_start = target.global_transform.origin
		var ray_end = target.global_transform.origin + Vector3(0, -1, 0) * (dynamic_distance + height)
		
		# Crear el objeto de parámetros para la consulta de rayos
		var ray_query = PhysicsRayQueryParameters3D.new()
		ray_query.from = ray_start
		ray_query.to = ray_end

		# Realizar el raycast
		var collision = get_world_3d().direct_space_state.intersect_ray(ray_query)

		if collision:
			# Ajustar la distancia según la colisión detectada
			dynamic_distance = lerp(min_distance, collision.position.distance_to(ray_start), 0.5)

		# Suavizado del seguimiento
		global_transform.origin = global_transform.origin.lerp(desired_position, follow_speed * delta)

		# Apuntar al auto desde atrás
		look_at(target_position + Vector3(0, 1, 0))
