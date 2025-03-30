extends Area3D

@export var destino: Node3D  # Referencia al destino, donde el carro debe ir al final de la vuelta
@export var label: Label  # Referencia al Label para mostrar el tiempo

var tiempo_vuelta : float = 0.0  # Tiempo de la vuelta actual
var primer_vuelta : float = 0.0  # Tiempo de la primera vuelta
var cronometro_activo : bool = false  # Estado del cronómetro

func _ready():
	# Conectamos la señal 'body_entered' a la función que maneja la detección del paso por la meta
	connect("body_entered", self, "_on_body_entered")

func _process(delta):
	if cronometro_activo:
		tiempo_vuelta += delta  # Acumulamos el tiempo cada frame
		label.text = "Tiempo: " + str(round(tiempo_vuelta * 100) / 100)  # Mostramos el tiempo con 2 decimales

func _on_body_entered(body):
	if body.is_in_group("carro"):  # Verificamos si el objeto que entra es un carro
		if !cronometro_activo:
			# Si no está activo el cronómetro, es la primera vuelta
			cronometro_activo = true
			tiempo_vuelta = 0  # Reiniciamos el cronómetro para la primera vuelta
		else:
			# Si ya estaba activo, es una vuelta posterior
			if primer_vuelta == 0.0:
				# Registramos la primera vuelta
				primer_vuelta = tiempo_vuelta
				print("Primera vuelta: ", primer_vuelta, " segundos")
			else:
				# Registramos los tiempos de las siguientes vueltas
				print("Vuelta completada en: ", tiempo_vuelta, " segundos")
			
			# Después de registrar el tiempo, desactivamos el cronómetro y reiniciamos
			cronometro_activo = false
			tiempo_vuelta = 0  # Reiniciamos el tiempo para la siguiente vuelta
