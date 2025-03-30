extends Control

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/user_interface/car_seleccion.tscn")
func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/user_interface/options_menu.tscn")
func _on_close_button_pressed() -> void:
	get_tree().quit()
	
