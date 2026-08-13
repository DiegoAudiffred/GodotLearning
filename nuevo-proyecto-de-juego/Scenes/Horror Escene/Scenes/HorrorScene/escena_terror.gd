extends Node2D

@export var personaje_escena: PackedScene
@export var dia_actual: Dias

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var video_stream_player: VideoStreamPlayer = $VideoStreamPlayer
@onready var camera_2d: Camera2D = $Camera2D

var visitante_actual: Personajes
var indice_visitante: int = 0


func _ready() -> void:
	if dia_actual and dia_actual.visitantes.size() > 0:
		aparecer_siguiente_visitante()


func aparecer_siguiente_visitante() -> void:
	if indice_visitante >= dia_actual.visitantes.size():
		print("Día terminado")
		return

	var datos_visitante = dia_actual.visitantes[indice_visitante]
	
	visitante_actual = personaje_escena.instantiate() as Personajes
	add_child(visitante_actual)
	
	visitante_actual.cargar_datos(datos_visitante)
	
	var centro_camara = returnCameraCenter() - Vector2(110,0)
	visitante_actual.entrar_a_escena(centro_camara)
	
	indice_visitante += 1


func returnCameraCenter() -> Vector2:
	#return camera_2d.get_screen_center_position()
	return camera_2d.get_target_position()

func playNewMusic(audio: AudioStream) -> void:
	audio_stream_player_2d.set_stream(audio)


func stopMusic() -> void:
	audio_stream_player_2d.stop()


func playMusic() -> void:
	audio_stream_player_2d.play()
