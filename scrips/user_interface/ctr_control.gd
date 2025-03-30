extends Control
# Apagado y encendido
@onready var shader_material = $crt_shader/Sprite2D.material
@onready var on_off_button = $on_off

# Referencias a los sliders
@onready var scan_line_amount = $controls/VBoxContainer/VBoxContainer/scan_line_amount
@onready var scan_line_strength = $controls/VBoxContainer/VBoxContainer/scan_line_strength
@onready var warp_amount = $controls/VBoxContainer2/VBoxContainer/warp_amount
@onready var noise_amount = $controls/VBoxContainer2/VBoxContainer/noise_amount
@onready var interference_amount = $controls/VBoxContainer2/VBoxContainer/interference_amount
@onready var grille_amount = $controls/VBoxContainer3/VBoxContainer/grille_amount
@onready var grille_size = $controls/VBoxContainer3/VBoxContainer/grille_size
@onready var vignette_amount = $controls/VBoxContainer4/VBoxContainer/vignette_amount
@onready var vignette_intensity = $controls/VBoxContainer4/VBoxContainer/vignette_intensity
@onready var aberration_amount = $controls/VBoxContainer5/VBoxContainer/aberration_amount
@onready var roll_line_amount = $controls/VBoxContainer6/VBoxContainer/roll_line_amount
@onready var roll_speed = $controls/VBoxContainer6/VBoxContainer/roll_speed
@onready var pixel_strength = $controls/VBoxContainer7/VBoxContainer/pixel_strength
@onready var reset_button = $VBoxContainer8/VBoxContainer/default

# Variables públicas para almacenar los valores de los sliders
var slider_values = {
	"scan_line_amount": 1.0,
	"scan_line_strength": -8.0,
	"warp_amount": 0.1,
	"noise_amount": 0.03,
	"interference_amount": 0.2,
	"grille_amount": 0.1,
	"grille_size": 1.0,
	"vignette_amount": 0.6,
	"vignette_intensity": 0.4,
	"aberration_amount": 0.5,
	"roll_line_amount": 0.3,
	"roll_speed": 1.0,
	"pixel_strength": -2.0
}

func _ready():
	print("Material del shader:", shader_material)
	
	# Conectar el botón de encendido/apagado
	on_off_button.toggled.connect(_on_on_off_toggled)
	
	# Configurar los rangos y los pasos de los sliders
	_set_slider_values()
	
	# Asignar valores iniciales a los sliders
	_set_slider_initial_values()

	# Verifica que los sliders estén en el grupo correcto
	for node in get_tree().get_nodes_in_group("crt_sliders"):
		print("Slider detectado:", node.name)
		node.value_changed.connect(_on_slider_value_changed)
	
	# Conectar botón de reset
	reset_button.pressed.connect(_on_reset_pressed)

	# Aplicar valores iniciales
	_apply_shader_values()

func _set_slider_values():
	# Establecer los rangos y pasos de los sliders
	scan_line_strength.min_value = -30.0
	scan_line_strength.max_value = -9.0
	scan_line_strength.step = (scan_line_strength.max_value - scan_line_strength.min_value) / 100.0
	
	scan_line_amount.min_value = 0.0
	scan_line_amount.max_value = 1.0
	scan_line_amount.step = (scan_line_amount.max_value - scan_line_amount.min_value) / 100.0
	
	warp_amount.min_value = -2.0
	warp_amount.max_value = 2.0
	warp_amount.step = (warp_amount.max_value - warp_amount.min_value) / 100.0
	
	noise_amount.min_value = 0.0
	noise_amount.max_value = 0.5
	noise_amount.step = (noise_amount.max_value - noise_amount.min_value) / 100.0
	
	interference_amount.min_value = 0.0
	interference_amount.max_value = 10.0
	interference_amount.step = (interference_amount.max_value - interference_amount.min_value) / 100.0
	
	grille_amount.min_value = -1.0
	grille_amount.max_value = 1.0
	grille_amount.step = (grille_amount.max_value - grille_amount.min_value) / 100.0
	
	grille_size.min_value = 0.0
	grille_size.max_value = 10.0
	grille_size.step = (grille_size.max_value - grille_size.min_value) / 100.0
	
	vignette_amount.min_value = 0.0
	vignette_amount.max_value = 1.0
	vignette_amount.step = (vignette_amount.max_value - vignette_amount.min_value) / 100.0
	
	vignette_intensity.min_value = -2.0
	vignette_intensity.max_value = 2.0
	vignette_intensity.step = (vignette_intensity.max_value - vignette_intensity.min_value) / 100.0
	
	roll_line_amount.min_value = 0.0
	roll_line_amount.max_value = 2.5
	roll_line_amount.step = 0.025
	
	roll_speed.min_value = 0.0
	roll_speed.max_value = 10.0
	roll_speed.step = 0.1
	
	pixel_strength.min_value = -2.0
	pixel_strength.max_value = 60.0
	pixel_strength.step = (pixel_strength.max_value - pixel_strength.min_value) / 100.0

func _set_slider_initial_values():
	# Asignar valores iniciales a los sliders
	scan_line_amount.value = CrtSettings.scan_line_amount  # Accede directamente a CrtSettings
	scan_line_strength.value = CrtSettings.scan_line_strength
	warp_amount.value = CrtSettings.warp_amount
	noise_amount.value = CrtSettings.noise_amount
	interference_amount.value = CrtSettings.interference_amount
	grille_amount.value = CrtSettings.grille_amount
	grille_size.value = CrtSettings.grille_size
	vignette_amount.value = CrtSettings.vignette_amount
	vignette_intensity.value = CrtSettings.vignette_intensity
	aberration_amount.value = CrtSettings.aberration_amount
	roll_line_amount.value = CrtSettings.roll_line_amount
	roll_speed.value = CrtSettings.roll_speed
	pixel_strength.value = CrtSettings.pixel_strength

func _on_slider_value_changed(value):
	print("Nuevo valor del slider:", value)
	print("Valor actualizado de CrtSettings.scan_line_amount:", CrtSettings.scan_line_amount)  # Ahora debería funcionar
	_update_slider_values()  # Actualiza los valores de los sliders en el diccionario
	_apply_shader_values()  # Aplica los valores al shader

func _update_slider_values():
	# Actualizar la variable pública con los nuevos valores
	CrtSettings.scan_line_amount = scan_line_amount.value
	CrtSettings.scan_line_strength = scan_line_strength.value
	CrtSettings.warp_amount = warp_amount.value
	CrtSettings.noise_amount = noise_amount.value
	CrtSettings.interference_amount = interference_amount.value
	CrtSettings.grille_amount = grille_amount.value
	CrtSettings.grille_size = grille_size.value
	CrtSettings.vignette_amount = vignette_amount.value
	CrtSettings.vignette_intensity = vignette_intensity.value
	CrtSettings.aberration_amount = aberration_amount.value
	CrtSettings.roll_line_amount = roll_line_amount.value
	CrtSettings.roll_speed = roll_speed.value
	CrtSettings.pixel_strength = pixel_strength.value

func _apply_shader_values():
	if shader_material and shader_material is ShaderMaterial:
		shader_material.set_shader_parameter("scan_line_amount", CrtSettings.scan_line_amount)
		shader_material.set_shader_parameter("scan_line_strength", CrtSettings.scan_line_strength)
		shader_material.set_shader_parameter("warp_amount", CrtSettings.warp_amount)
		shader_material.set_shader_parameter("noise_amount", CrtSettings.noise_amount)
		shader_material.set_shader_parameter("interference_amount", CrtSettings.interference_amount)
		shader_material.set_shader_parameter("grille_amount", CrtSettings.grille_amount)
		shader_material.set_shader_parameter("grille_size", CrtSettings.grille_size)
		shader_material.set_shader_parameter("vignette_amount", CrtSettings.vignette_amount)
		shader_material.set_shader_parameter("vignette_intensity", CrtSettings.vignette_intensity)
		shader_material.set_shader_parameter("aberration_amount", CrtSettings.aberration_amount)
		shader_material.set_shader_parameter("roll_line_amount", CrtSettings.roll_line_amount)
		shader_material.set_shader_parameter("roll_speed", CrtSettings.roll_speed)
		shader_material.set_shader_parameter("pixel_strength", CrtSettings.pixel_strength)

func _on_reset_pressed():
	# Restaurar valores predeterminados en los sliders
	scan_line_amount.value = 1.0
	scan_line_strength.value = -8.0
	warp_amount.value = 0.1
	noise_amount.value = 0.03
	interference_amount.value = 0.2
	grille_amount.value = 0.1
	grille_size.value = 1.0
	vignette_amount.value = 0.6
	vignette_intensity.value = 0.4
	aberration_amount.value = 0.5
	roll_line_amount.value = 0.3
	roll_speed.value = 1.0
	pixel_strength.value = -2.0

	# Actualizar los valores en CrtSettings para reflejar los valores predeterminados
	CrtSettings.scan_line_amount = scan_line_amount.value
	CrtSettings.scan_line_strength = scan_line_strength.value
	CrtSettings.warp_amount = warp_amount.value
	CrtSettings.noise_amount = noise_amount.value
	CrtSettings.interference_amount = interference_amount.value
	CrtSettings.grille_amount = grille_amount.value
	CrtSettings.grille_size = grille_size.value
	CrtSettings.vignette_amount = vignette_amount.value
	CrtSettings.vignette_intensity = vignette_intensity.value
	CrtSettings.aberration_amount = aberration_amount.value
	CrtSettings.roll_line_amount = roll_line_amount.value
	CrtSettings.roll_speed = roll_speed.value
	CrtSettings.pixel_strength = pixel_strength.value

	# Aplicar los cambios al shader
	_apply_shader_values()

# Función para activar/desactivar el shader
func _on_on_off_toggled(button_pressed):
	# Activar o desactivar el shader de la pantalla CRT
	$crt_shader/Sprite2D.material = shader_material if button_pressed else null
	
	# Guardar el estado del efecto en la variable global
	CrtSettings.is_screen_off = not button_pressed
	
	# Mostrar el estado por consola (opcional)
	if CrtSettings.is_screen_off:
		print("Efecto apagado.")
	else:
		print("Efecto activado.")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/user_interface/options_menu.tscn")
