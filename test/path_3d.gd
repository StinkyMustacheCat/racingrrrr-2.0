extends Node3D

@export var profile_scene: PackedScene  # La escena del perfil
@export var resolution: int = 50  # Cantidad de segmentos

func _ready():
	if not profile_scene:
		print("No hay perfil asignado")
		return

	for i in range(resolution):
		var profile = profile_scene.instantiate()
		add_child(profile)

		var t = i / float(resolution)  # Posición a lo largo del path (0 a 1)
		profile.position = $Curve3D.sample_baked(t * $Curve3D.get_baked_length())
		profile.look_at($Curve3D.sample_baked((t + 0.01) * $Curve3D.get_baked_length()), Vector3.UP)
