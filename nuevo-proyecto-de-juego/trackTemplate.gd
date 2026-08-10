class_name TrackTemplate
extends Node2D

enum EstadoCarrera { Start, Early_Race, Mid_Race, Late_Race, Last_Spurt, End }

@export var trackDistance: float = 2000.0
var trackStar: float = 0.0
@export var curvas: Array[float] = []
@export var bajadas: Array[Vector2] = []
@export var subidas: Array[Vector2] = []
var lista_participantes: Array[PackedScene] = []
var order: Array = []
var estado_actual: EstadoCarrera = EstadoCarrera.Start

func _ready() -> void:
	antesDeIniciar()

func _process(delta: float) -> void:
	if estado_actual != EstadoCarrera.End:
		actualizar_posiciones()

#Fases
#Fase Inicial
#Se guardan las corredoras enviadas desde el main menu en una lista de nodos
func cargar_participantes(escenas_corredoras: Array[PackedScene]) -> void:
	lista_participantes = escenas_corredoras	
#La funcion ready llama aqui	
func antesDeIniciar() -> void:
	estado_actual = EstadoCarrera.Start
	generar_corredoras()
#Con la lista llama las instancias de dichos nodos y crea los hijos en la escena
func generar_corredoras() -> void:
	var carril_y: float = 100.0
	var separacion_carriles: float = 50.0
	
	for i in range(lista_participantes.size()):
		var escena: PackedScene = lista_participantes[i]
		var corredora := escena.instantiate()
		
		corredora.global_position = Vector2(0, carril_y + (i * separacion_carriles))
		
		add_child(corredora)
		

	
func carreraIniciada() -> void:
	estado_actual = EstadoCarrera.Early_Race

func carreraMedia() -> void:
	estado_actual = EstadoCarrera.Mid_Race
	
func carreraLate() -> void:
	estado_actual = EstadoCarrera.Late_Race
	
func carreraLast() -> void:
	estado_actual = EstadoCarrera.Last_Spurt

func terminoCarrera() -> void:
	estado_actual = EstadoCarrera.End
#Fases

func distanciaRestante(id_corredora: int) -> float:
	var nodo_corredora: Node2D = obtener_nodo_por_id(id_corredora)
	
	if nodo_corredora:
		var distancia_recorrida: float = nodo_corredora.global_position.x
		var restante: float = trackDistance - distancia_recorrida
		return maxf(0.0, restante)
	
	return -1.0

func ha_terminado(id_corredora: int) -> bool:
	return distanciaRestante(id_corredora) == 0.0
	
func obtener_fase_corredora(id_corredora: int) -> EstadoCarrera:
	var nodo: Node2D = obtener_nodo_por_id(id_corredora)
	if not nodo:
		return EstadoCarrera.Start
		
	var pos_x: float = nodo.global_position.x
	
	if pos_x <= 0.0:
		return EstadoCarrera.Start
		
	var porcentaje: float = pos_x / trackDistance
	
	if porcentaje < 0.33:
		return EstadoCarrera.Early_Race
	elif porcentaje < 0.66:
		return EstadoCarrera.Mid_Race
	elif porcentaje < 0.83:
		return EstadoCarrera.Late_Race
	elif porcentaje < 1.0:
		return EstadoCarrera.Last_Spurt
	else:
		return EstadoCarrera.End

# Controla la fase general de la competencia basada en la lider de la carrera
func actualizar_fase_global_carrera(posicion_lider: float) -> void:
	if estado_actual == EstadoCarrera.Start or estado_actual == EstadoCarrera.End:
		return
		
	var porcentaje: float = posicion_lider / trackDistance
	
	if porcentaje < 0.33:
		estado_actual = EstadoCarrera.Early_Race
	elif porcentaje < 0.66:
		estado_actual = EstadoCarrera.Mid_Race
	elif porcentaje < 0.83:
		estado_actual = EstadoCarrera.Late_Race
	elif porcentaje < 1.0:
		estado_actual = EstadoCarrera.Last_Spurt
	else:
		estado_actual = EstadoCarrera.End

# ==============================================================================
# MÉTODOS DE CONSULTA DE TERRENO (Para que los usen las corredoras)
# ==============================================================================

func esta_en_subida(pos_x: float) -> bool:
	for rango in subidas:
		if pos_x >= rango.x and pos_x <= rango.y:
			return true
	return false

func esta_en_bajada(pos_x: float) -> bool:
	for rango in bajadas:
		if pos_x >= rango.x and pos_x <= rango.y:
			return true
	return false

func esta_en_curva(pos_x: float, margen: float = 50.0) -> bool:
	for punto_curva in curvas:
		if absf(pos_x - punto_curva) <= margen:
			return true
	return false

# ==============================================================================
# MÉTODOS PARA OBTENER POSICIONES Y NODOS
# ==============================================================================

# Registra a los participantes buscando cualquier nodo que implemente la interfaz/método 'get_id'
func actualizar_posiciones() -> void:
	var corredoras: Array = []
	
	for hijo in get_children():
		if hijo.has_method("get_id"):
			corredoras.append(hijo)
	
	if corredoras.is_empty():
		return
		
	corredoras.sort_custom(func(a, b): return a.global_position.x > b.global_position.x)
	
	order.clear()
	for corredora in corredoras:
		order.append(corredora.get_id())
		
	var id_lider: int = returnFirst()
	var nodo_lider: Node2D = obtener_nodo_por_id(id_lider)
	if nodo_lider:
		actualizar_fase_global_carrera(nodo_lider.global_position.x)

# Devuelve la posición ordinal (1.º, 2.º, 3.er lugar) pasando la ID de la corredora
func obtener_posicion_corredora(id_buscado: int) -> int:
	for i in range(order.size()):
		if order[i] == id_buscado:
			return i + 1
	return -1

# Devuelve la ID de la corredora en primer lugar
func returnFirst() -> int:
	if not order.is_empty():
		return order[0]
	return -1

# Devuelve una lista con los IDs del podio
func obtener_podio(cantidad: int = 3) -> Array:
	if order.is_empty():
		return []
	var limite: int = mini(cantidad, order.size())
	return order.slice(0, limite)

# Auxiliar para obtener el nodo Node2D correspondiente a una ID sin asumir su nombre de escena
func obtener_nodo_por_id(id_buscado: int) -> Node2D:
	for hijo in get_children(): #todos los nodos 2d heredados que tenga la escena
		if hijo.has_method("get_id") and hijo.get_id() == id_buscado: #metodo en la clase y que si sea el imismo id
			return hijo
	return null


	

func es_ganadora(id_buscado: int) -> bool:
	return returnFirst() == id_buscado
		
