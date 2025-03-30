extends Node2D
# Referencias a los botones
var button1
var button2
# Función para el primer botón (Selecciona el carro 1)
func _on_button_pressed() -> void:
	print("Botón 1 presionado!")
	GameData.selected_car = "car_1"  # Guarda la selección en la variable global
	get_tree().change_scene_to_file("res://scenes/gameplay/test_track.tscn")  # Cambiar a la siguiente escena
# Función para el segundo botón (Selecciona el carro 2)
func _on_button_2_pressed() -> void:
	print("Botón 2 presionado!")
	GameData.selected_car = "car_2"  # Guarda la selección en la variable global
	get_tree().change_scene_to_file("res://scenes/gameplay/test_track.tscn")  # Cambiar a la siguiente escena
