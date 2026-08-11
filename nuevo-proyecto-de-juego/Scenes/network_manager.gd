extends Control

const PUERTO: int = 8910

@export var personajes: Array[PackedScene] = []
@export var escena_carrera: PackedScene

@onready var line_edit_ip: LineEdit = $VBoxContainer/LineEditIP

func _ready() -> void:
	multiplayer.peer_connected.connect(_al_conectarse_jugador)
	multiplayer.peer_disconnected.connect(_al_desconectarse_jugador)

func _on_btn_host_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PUERTO)
	if error != OK:
		print("Error al crear el servidor: ", error)
		return
	
	multiplayer.multiplayer_peer = peer
	_cargar_carrera()

func _on_btn_join_pressed() -> void:
	var ip = line_edit_ip.text if line_edit_ip.text != "" else "127.0.0.1"
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(ip, PUERTO)
	if error != OK:
		print("Error al conectar al servidor: ", error)
		return
	
	multiplayer.multiplayer_peer = peer
	$VBoxContainer.hide()

func _cargar_carrera() -> void:
	$VBoxContainer.hide()
	var mapa = escena_carrera.instantiate()
	get_tree().root.add_child(mapa)
	
	var spawner = mapa.get_node("MultiplayerSpawner")
	if spawner:
		spawner.spawn_function = _al_spawnear_jugador
	
	_crear_jugador_en_carrera(1, mapa)

func _al_conectarse_jugador(id: int) -> void:
	if multiplayer.is_server():
		var mapa = get_tree().root.get_node_or_null("Carrera1")
		if mapa:
			_crear_jugador_en_carrera(id, mapa)

func _al_desconectarse_jugador(id: int) -> void:
	if multiplayer.is_server():
		var mapa = get_tree().root.get_node_or_null("Carrera1")
		if mapa:
			var contenedor = mapa.get_node_or_null("Jugadores")
			if contenedor:
				var jugador = contenedor.get_node_or_null(str(id))
				if jugador:
					jugador.queue_free()

func _crear_jugador_en_carrera(id: int, mapa: Node) -> void:
	var contenedor = mapa.get_node("Jugadores")
	var total_jugadores = contenedor.get_child_count()
	var indice_personaje = total_jugadores % personajes.size()
	
	var nuevo_jugador = personajes[indice_personaje].instantiate()
	nuevo_jugador.name = str(id)
	
	var puntos_salida = mapa.get_node_or_null("PuntosSalida")
	if puntos_salida and puntos_salida.get_child_count() > total_jugadores:
		nuevo_jugador.global_position = puntos_salida.get_child(total_jugadores).global_position
	
	contenedor.add_child(nuevo_jugador)

func _al_spawnear_jugador(data):
	return
