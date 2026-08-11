class_name TrackTemplate
extends Node2D

enum EstadoCarrera { Start, Early_Race, Mid_Race, Late_Race, Last_Spurt, End }

@export var trackDistance: float = 0
var trackStar: float = 0.0
@export var curvas: Array[Vector2] = []
@export var bajadas: Array[Vector2] = []
@export var subidas: Array[Vector2] = []
var lista_participantes: Array[PackedScene] = []
var order: Array = []
var estado_actual: EstadoCarrera = EstadoCarrera.Start
@onready var race_camera: Camera2D = $raceCamera
@onready var racer_name: Label = $racerName
@onready var race_name_banner: Sprite2D = $raceNameBanner
@export var velocidadCamara: float = 200


func _ready() -> void:
	antesDeIniciar()
func _process(delta: float) -> void:
	if estado_actual != EstadoCarrera.End:
		actualizar_posiciones()
		
		var id_lider: int = returnFirst()
		var nodo_lider: Node2D = obtener_nodo_por_id(id_lider)
		
		if nodo_lider:
			# Pasamos la posicion X recorrida, NO la restante
			actualizar_fase_global_carrera(nodo_lider.global_position.x)
			
		for id_corredora in order:
			var nodo_corredora: Node2D = obtener_nodo_por_id(id_corredora)
			if not nodo_corredora:
				continue
				
			if esta_en_subida(nodo_corredora.global_position.x):
				nodo_corredora.increase_stamina_usage(1.5) 
			elif esta_en_bajada(nodo_corredora.global_position.x):    
				nodo_corredora.decrease_stamina_usage(1.5) 
			else:
				nodo_corredora.set_normal_stamina_usage()
			
			# Evaluación de habilidades en cada tick
			if nodo_corredora.has_method("evaluar_habilidades"):
				nodo_corredora.evaluar_habilidades(self)

#Fases
#==============Fase Inicial====================
#Se guardan las corredoras enviadas desde el main menu en una lista de nodos
func cargar_participantes(escenas_corredoras: Array[PackedScene]) -> void:
	lista_participantes = escenas_corredoras	
#La funcion ready llama aqui	
func antesDeIniciar() -> void:
	estado_actual = EstadoCarrera.Start
	await _animar_titulo()
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
#titulo
func _animar_titulo() -> void:
	# Espera a que pase un frame del motor para garantizar que la cámara calculó su posición real en pantalla
	await get_tree().process_frame
	
	# Obtiene las coordenadas del centro exacto de la vista actual de la cámara en el mundo 2D
	var centro_camara: Vector2 = race_camera.get_screen_center_position()
	
	# Calcula la posición inicial desplazando el banner 1200 píxeles hacia la izquierda del centro de la cámara
	var inicio_fuera_pantalla: Vector2 = centro_camara + Vector2(-1200, 0)
	
	# Asigna la posición inicial calculada al Sprite2D para que empiece fuera de la pantalla
	race_name_banner.global_position = inicio_fuera_pantalla
	
	# Asegura que la opacidad del banner esté al 100% (completamente visible) antes de animar
	race_name_banner.modulate.a = 1.0
	
	# Muestra el nodo en caso de que estuviera oculto previamente
	race_name_banner.visible = true
	
	# Crea un nuevo Tween en Godot para manejar las animaciones por código
	var tween := create_tween()
	
	# Anima la posición global del banner hacia el centro de la cámara durante 1.2 segundos con un frenado suave al final
	tween.tween_property(race_name_banner, "global_position", centro_camara, 1.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	# Hace una pausa en la secuencia del Tween dejando el banner quieto en el centro durante 1.0 segundo
	tween.tween_interval(1.0)
	
	# Anima la propiedad del canal alfa (transparencia) hacia 0.0 en 0.8 segundos para hacer un desvanecimiento (fade out)
	tween.tween_property(race_name_banner, "modulate:a", 0.0, 0.8)
	
	# Detiene la ejecución de esta función hasta que todas las animaciones del Tween hayan terminado
	await tween.finished
	
	# Oculta el nodo al finalizar para liberar recursos visuales y dejar la pantalla limpia
	race_name_banner.visible = false

#==============Fase Inicial====================
#==============Fase inicio====================
#camara
func mover_camara_ida_y_vuelta() -> void:
	await get_tree().process_frame
	
	var posicion_inicial: Vector2 = race_camera.global_position
	var posicion_destino: Vector2 = posicion_inicial + Vector2(trackDistance, 0.0)
	
	var duracion: float = trackDistance / velocidadCamara
	
	var tween := create_tween()
	
	tween.tween_property(race_camera, "global_position", posicion_destino, duracion).set_trans(Tween.TRANS_LINEAR)
	
	#tween.tween_property(race_camera, "global_position", posicion_inicial, duracion).set_trans(Tween.TRANS_LINEAR)
	
	await tween.finished

# Habilidades pasivas / iniciales al arrancar la carrera
func greenSkills() -> void:
	for id_corredora in order:
		var nodo_corredora: Node2D = obtener_nodo_por_id(id_corredora)
		if nodo_corredora and nodo_corredora.has_method("evaluar_habilidades"):
			nodo_corredora.evaluar_habilidades(self)

#==============Fase inicio====================
# Resetea las habilidades de todas las corredoras en la escena
func reiniciar_habilidades_carrera() -> void:
	for id_corredora in order:
		var nodo_corredora: Node2D = obtener_nodo_por_id(id_corredora)
		if nodo_corredora and nodo_corredora.has_method("reiniciar_habilidades"):
			nodo_corredora.reiniciar_habilidades()
# Auxiliar para obtener el nodo Node2D correspondiente a una ID sin asumir su nombre de escena
func obtener_nodo_por_id(id_buscado: int) -> Node2D:
	for hijo in get_children(): #todos los nodos 2d heredados que tenga la escena
		if hijo.has_method("get_id") and hijo.get_id() == id_buscado: #metodo en la clase y que si sea el imismo id
			return hijo #regresa el nodo 
	return null

	
func carreraIniciada() -> void:
	mover_camara_ida_y_vuelta()
	
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
	if estado_actual == EstadoCarrera.End:
		return
		
	var porcentaje: float = clampf(posicion_lider / trackDistance, 0.0, 1.0)
	var nueva_fase: EstadoCarrera = estado_actual
	
	if porcentaje < 0.33:
		nueva_fase = EstadoCarrera.Early_Race
	elif porcentaje < 0.66:
		nueva_fase = EstadoCarrera.Mid_Race
	elif porcentaje < 0.83:
		nueva_fase = EstadoCarrera.Late_Race
	elif porcentaje < 1.0:
		nueva_fase = EstadoCarrera.Last_Spurt
	else:
		nueva_fase = EstadoCarrera.End
	# Solo actuar cuando hay un cambio de fase real
	print(nueva_fase)
	if nueva_fase != estado_actual:
		estado_actual = nueva_fase
		_al_cambiar_fase_global(estado_actual)

func _al_cambiar_fase_global(fase: EstadoCarrera) -> void:
	match fase:
		EstadoCarrera.Early_Race:
			carreraIniciada()
		EstadoCarrera.Mid_Race:
			carreraMedia()
		EstadoCarrera.Late_Race:
			carreraLate()
		EstadoCarrera.Last_Spurt:
			carreraLast()
		EstadoCarrera.End:
			terminoCarrera()
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
	for rango in curvas:
		if pos_x >= rango.x and pos_x <= rango.y:
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
		
	#var id_lider: int = returnFirst()
	#var nodo_lider: Node2D = obtener_nodo_por_id(id_lider)
	#if nodo_lider:
	#	actualizar_fase_global_carrera(nodo_lider.global_position.x)

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

func es_ganadora(id_buscado: int) -> bool:
	return returnFirst() == id_buscado
		
