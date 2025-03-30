extends Node3D  # Escena de la pista en 3D

# Referencias a los modelos de carros
var car_1_model
var car_2_model
var selected_car_model

func _ready():
	# Verificar qué carro fue seleccionado
	match GameData.selected_car:
		"car_1":
			# Usar instantiate() en lugar de instance()
			selected_car_model = preload("res://scenes/cars/juggernaut.tscn").instantiate()
		"car_2":
			# Usar instantiate() en lugar de instance()
			selected_car_model = preload("res://scenes/cars/tempest.tscn").instantiate()
		_:
			print("Error: No se ha seleccionado un carro válido.")
			return

	# Asegúrate de que el modelo del carro sea un MeshInstance3D para 3D
	add_child(selected_car_model)
	selected_car_model.position = Vector3(0, 0, 0)  # Posición inicial del carro en la pista
