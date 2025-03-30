extends Control
#menu de pausa
func _physics_process(_delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused  = not get_tree().paused
		$pause.visible = not $pause.visible

func _on_resume_pressed() -> void:
	get_tree().paused  = not get_tree().paused
	$pause.visible = not $pause.visible

func _on_options_pressed() -> void:
	get_tree().paused  = not get_tree().paused
	get_tree().change_scene_to_file("res://scenes/user_interface/options_menu.tscn")

func _on_main_menu_pressed() -> void:
	get_tree().paused  = not get_tree().paused
	get_tree().change_scene_to_file("res://scenes/user_interface/menu.tscn")
	

func _on_quit_pressed() -> void:
	get_tree().quit()
