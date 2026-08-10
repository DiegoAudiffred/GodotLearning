extends CharacterBody2D

var id: int = 0
var speed: float = 0.0
var estamina: float = 0.0
var estaminaactual: float = 0.0
var consumo_estamina: float = 100.0
var regeneracion_estamina: float = 100.0
var nombre_corredora: String = ""
var pace: String = ""
var extra_speed: float = 2.0
var racePosition: int = 0



@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	var velocidad_actual: float = speed
	var consumo_actual: float = consumo_estamina
	
	if Input.is_action_pressed("Shift") and estaminaactual > 0.0:
		velocidad_actual *= extra_speed
		consumo_actual *= 2.0

	if direction != Vector2.ZERO:
		if estaminaactual > 0.0:
			velocity = direction * velocidad_actual
			estaminaactual = maxf(0.0, estaminaactual - (consumo_actual * delta))
		else:
			velocity = Vector2.ZERO
	else:
		velocity = velocity.move_toward(Vector2.ZERO, velocidad_actual)
		if estaminaactual < estamina:
			estaminaactual = minf(estamina, estaminaactual + (regeneracion_estamina * delta))

	_update_animation(direction)
	move_and_slide()

func get_stamina() -> float:
	return estaminaactual
	
func get_id() -> int:
	return id

func _update_animation(direction: Vector2) -> void:
	if direction != Vector2.ZERO and velocity != Vector2.ZERO:
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
			pace = chica["pace"]
			break

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass
