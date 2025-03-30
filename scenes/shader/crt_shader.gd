extends Node2D

# Ruta al nodo 2D que tiene el material con el shader
@onready var sprite_material = $Sprite2D.material  # Asegúrate de que esta ruta sea correcta

func _ready():
	# Verifica si el material es un ShaderMaterial
	if sprite_material and sprite_material is ShaderMaterial:
		# Verifica si el efecto está apagado usando la variable global is_screen_off
		if CrtSettings.is_screen_off:
			# Si el efecto está apagado, desactivar el material del sprite
			$Sprite2D.material = null
		else:
			# Si el efecto está encendido, aplicar los valores del shader
			# Obtener los valores globales de CrtSettings
			var scan_line_amount = CrtSettings.scan_line_amount
			var scan_line_strength = CrtSettings.scan_line_strength
			var warp_amount = CrtSettings.warp_amount
			var noise_amount = CrtSettings.noise_amount
			var interference_amount = CrtSettings.interference_amount
			var grille_amount = CrtSettings.grille_amount
			var grille_size = CrtSettings.grille_size
			var vignette_amount = CrtSettings.vignette_amount
			var vignette_intensity = CrtSettings.vignette_intensity
			var aberration_amount = CrtSettings.aberration_amount
			var roll_line_amount = CrtSettings.roll_line_amount
			var roll_speed = CrtSettings.roll_speed
			var pixel_strength = CrtSettings.pixel_strength

			# Aplicar los valores a los parámetros del shader
			sprite_material.set_shader_parameter("scan_line_amount", scan_line_amount)
			sprite_material.set_shader_parameter("scan_line_strength", scan_line_strength)
			sprite_material.set_shader_parameter("warp_amount", warp_amount)
			sprite_material.set_shader_parameter("noise_amount", noise_amount)
			sprite_material.set_shader_parameter("interference_amount", interference_amount)
			sprite_material.set_shader_parameter("grille_amount", grille_amount)
			sprite_material.set_shader_parameter("grille_size", grille_size)
			sprite_material.set_shader_parameter("vignette_amount", vignette_amount)
			sprite_material.set_shader_parameter("vignette_intensity", vignette_intensity)
			sprite_material.set_shader_parameter("aberration_amount", aberration_amount)
			sprite_material.set_shader_parameter("roll_line_amount", roll_line_amount)
			sprite_material.set_shader_parameter("roll_speed", roll_speed)
			sprite_material.set_shader_parameter("pixel_strength", pixel_strength)
