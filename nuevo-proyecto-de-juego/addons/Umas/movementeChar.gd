class_name Umamusume
extends CharacterBody2D

var id: int = 0
var speed: float = 0.0
var estamina: float = 0.0
var estaminaactual: float = 0.0
var consumo_estamina: float = 100.0
var regeneracion_estamina: float = 100.0
var nombre_corredora: String = ""
var extra_speed: float = 2.0
var racePosition: int = 0
var acceleration: float = 1.0
var last_spurt: bool = false
enum Pace { Front_Runner, Pace_Chaser, Late_Surger, End_Closer }
@export var pace: Pace = Pace.Front_Runner

@export var habilidades: Array[HabilidadData] = []
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
#func _enter_tree() -> void:
#	set_multiplayer_authority(name.to_int())


	# ... Aquí va todo tu código actual de movimiento y estamina ...
func _physics_process(delta: float) -> void:
#	if not is_multiplayer_authority():
#		return
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	var velocidad_actual: float = speed
	var multiplicador_consumo: float = 1.0
	
	if Input.is_action_pressed("Shift") and estaminaactual > 0.0:
		velocidad_actual *= extra_speed
		multiplicador_consumo = 2.0
	
	if direction != Vector2.ZERO:
		if estaminaactual > 0.0:
			velocity = direction * velocidad_actual * acceleration
			estaminaactual = maxf(0.0, estaminaactual - (consumo_estamina * multiplicador_consumo * delta))
		else:
			velocity = Vector2.ZERO
	else:
		velocity = velocity.move_toward(Vector2.ZERO, velocidad_actual)
		if estaminaactual < estamina:
			estaminaactual = minf(estamina, estaminaactual + (regeneracion_estamina * delta))

	_update_animation(direction)
	move_and_slide()
func increase_stamina_usage(increased)->void:
	consumo_estamina = consumo_estamina * increased
	print("consumo actual por subida"+str(consumo_estamina))

func decrease_stamina_usage(increased)->void:
	consumo_estamina = consumo_estamina / increased
	print("consumo actual por bajada"+str(consumo_estamina))
	
func set_normal_stamina_usage()->void:
	consumo_estamina = 100
	
func increse_acceleration(increase)->void:
	acceleration = acceleration+increase 
	
func decrease_acceleration(decrease)->void:
	acceleration = acceleration-decrease 	

func normal_acceleration()->void:
	acceleration = 1
	
func get_stamina() -> float:
	return estaminaactual
		
func get_id() -> int:
	return id

func get_nombre() -> String:
	return nombre_corredora

func set_last_spurt() -> void:
	last_spurt = true
	
func remove_last_spurt() -> void:
	last_spurt = false

func _update_animation(direction: Vector2) -> void:
	if direction != Vector2.ZERO and velocity != Vector2.ZERO:
		if last_spurt:
			sprite.play("last_spurt")
			if direction.x != 0:
				sprite.flip_h = direction.x > 0
		else:
			sprite.play("walk")
			if direction.x != 0:
				sprite.flip_h = direction.x > 0
	else:
		sprite.play("afk")
		
		
#https://www.spriters-resource.com/pc_computer/umamusumeprettyderbypartydash/asset/471742/
func cargar_datos(id_buscado: int) -> void:
	for chica in DatosUmamusume.LISTA:
		if chica["id"] == id_buscado:
			id = chica["id"]
			speed = chica["velocidad"]
			estamina = chica["estamina"]
			estaminaactual = estamina
			nombre_corredora = chica["nombre"]
			match chica["pace"]:
				"Front_Runner": pace = Pace.Front_Runner
				"Pace_Chaser": pace = Pace.Pace_Chaser
				"Late_Surger": pace = Pace.Late_Surger
				"End_Closer": pace = Pace.End_Closer			
			#if chica.has("habilidades"):
			#	habilidades = chica["habilidades"].duplicate()
			break

# En umamusume.gd

# Evalúa todas sus habilidades contra el estado actual de la pista
func evaluar_habilidades(contexto_carrera: TrackTemplate) -> void:
	for habilidad in habilidades:
		if habilidad:
			habilidad.intentar_activar(self, contexto_carrera)

# Limpia el estado de 'ya_usada' en sus habilidades al reiniciar carrera
func reiniciar_habilidades() -> void:
	for habilidad in habilidades:
		if habilidad:
			habilidad.resetear_habilidad()
