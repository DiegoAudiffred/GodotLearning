class_name RaceStart
extends RefCounted
#esto es para poder cargar bien cuando se divide el codigo pista: TrackTemplate
func cargar_participantes(pista: TrackTemplate, escenas_corredoras: Array[PackedScene]) -> void:
	pista.lista_participantes = escenas_corredoras

func antesDeIniciar(pista: TrackTemplate) -> void:
	pista.estado_actual = pista.EstadoCarrera.Start
	generar_corredoras(pista)

func generar_corredoras(pista: TrackTemplate) -> void:
	var carril_y: float = 100.0
	var separacion_carriles: float = 50.0
	
	for i in range(pista.lista_participantes.size()):
		var escena: PackedScene = pista.lista_participantes[i]
		var corredora := escena.instantiate()
		
		corredora.global_position = Vector2(0, carril_y + (i * separacion_carriles))
		
		pista.add_child(corredora)
