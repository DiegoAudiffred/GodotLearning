class_name HabilidadData
extends Resource

@export var id: String = ""
@export var nombre: String = ""
@export_multiline var descripcion: String = ""
@export var duracion: float = 0.0

@export_enum("Buff", "Debuff", "Heal") var tipo: String = "Buff"

@export_group("Condiciones de Activación")
@export var usar_condiciones: bool = true

# Si esta opción está activa, se ignorará la lista de fases y funcionará en cualquier momento
@export var cualquier_fase: bool = true

# Permite seleccionar una o múltiples fases permitidas desde el inspector
@export var fases_permitidas: Array[TrackTemplate.EstadoCarrera] = [TrackTemplate.EstadoCarrera.Start]

@export var posicion_maxima: int = 0 
@export var posicion_minima: int = 0 

@export var estamina_maxima_porcentaje: float = 0.0 

@export var requiere_subida: bool = false
@export var requiere_bajada: bool = false
@export var requiere_curva: bool = false

@export var pace_requerido: Array[Umamusume.Pace] = [Umamusume.Pace.Front_Runner]#@export var pace: Pace = Pace.Front_Runner

@export_group("Modificadores Positivos (Buffs)")
@export var multiplicador_velocidad: float = 1.0 
@export var multiplicador_aceleracion: float = 1.0
@export var recuperacion_estamina: float = 0.0

@export_group("Modificadores Negativos (Debuffs/Penalizaciones)")
@export var reduccion_velocidad: float = 1.0 
@export var reduccion_aceleracion: float = 1.0
@export var reduccion_estamina: float = 0.0

var ya_usada: bool = false

func intentar_activar(corredora: CharacterBody2D, contexto_carrera: TrackTemplate) -> bool:
	if ya_usada:
		return false

	if usar_condiciones and not _validar_condiciones(corredora, contexto_carrera):
		return false

	_ejecutar(corredora)
	return true

func _validar_condiciones(corredora: CharacterBody2D, contexto_carrera: TrackTemplate) -> bool:
	# 1. Validar Fase de la carrera (Soporta múltiples fases o cualquiera)
	if not cualquier_fase:
		# Si la fase actual de la pista no está en la lista de permitidas, no se activa
		if not contexto_carrera.estado_actual in fases_permitidas:
			return false

	# 2. Validar Posición en la carrera
	if posicion_maxima > 0 or posicion_minima > 0:
		var pos_actual: int = contexto_carrera.obtener_posicion_corredora(corredora.get_id())
		if pos_actual != -1:
			if posicion_maxima > 0 and pos_actual > posicion_maxima:
				return false
			if posicion_minima > 0 and pos_actual < posicion_minima:
				return false

	# 3. Validar Umbral de Estamina
	if estamina_maxima_porcentaje > 0.0:
		var porcentaje_actual: float = corredora.estaminaactual / corredora.estamina
		if porcentaje_actual > estamina_maxima_porcentaje:
			return false

	# 4. Validar Terreno actual de la corredora
	var pos_x: float = corredora.global_position.x
	if requiere_subida and not contexto_carrera.esta_en_subida(pos_x):
		return false
	if requiere_bajada and not contexto_carrera.esta_en_bajada(pos_x):
		return false
	if requiere_curva and not contexto_carrera.esta_en_curva(pos_x):
		return false

	# 5. Validar Pace / Estrategia
	if not pace_requerido.is_empty() and not corredora.pace in pace_requerido:
		return false

	return true

func _ejecutar(corredora: CharacterBody2D) -> void:
	ya_usada = true
	print("Activando " + nombre + " (" + tipo + ") en " + corredora.get_nombre())

	corredora.speed *= multiplicador_velocidad
	corredora.acceleration *= multiplicador_aceleracion

	corredora.speed *= reduccion_velocidad
	corredora.acceleration *= reduccion_aceleracion

	if recuperacion_estamina > 0.0:
		corredora.estaminaactual = minf(corredora.estamina, corredora.estaminaactual + recuperacion_estamina)

	if reduccion_estamina > 0.0:
		corredora.estaminaactual = maxf(0.0, corredora.estaminaactual - reduccion_estamina)

	if duracion > 0.0:
		_manejar_duracion(corredora)

func _manejar_duracion(corredora: CharacterBody2D) -> void:
	await corredora.get_tree().create_timer(duracion).timeout

	if multiplicador_velocidad != 0.0:
		corredora.speed /= multiplicador_velocidad
	if multiplicador_aceleracion != 0.0:
		corredora.acceleration /= multiplicador_aceleracion

	if reduccion_velocidad != 0.0:
		corredora.speed /= reduccion_velocidad
	if reduccion_aceleracion != 0.0:
		corredora.acceleration /= reduccion_aceleracion

	print("Terminó el efecto de " + nombre + " en " + corredora.get_nombre())

func resetear_habilidad() -> void:
	ya_usada = false
