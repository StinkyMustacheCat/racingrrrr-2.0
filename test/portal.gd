extends Area3D

@export var destino: Node3D  # Referencia al destino

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("carro"):  # Asegúrate de que el coche esté en este grupo
		body.global_transform.origin = destino.global_transform.origin
