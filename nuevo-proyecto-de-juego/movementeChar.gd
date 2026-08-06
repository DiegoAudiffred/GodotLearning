extends CharacterBody2D

var id: int = 0
var speed: float = 0.0
var estamina: float = 0.0
var estaminaactual: float = 0.0
var consumo_estamina: float = 100.0
var regeneracion_estamina: float = 100.0
var nombre_corredora: String = ""
var pace: String = ""

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction != Vector2.ZERO:
		if estaminaactual > 0.0:
			velocity = direction * speed
			estaminaactual = maxf(0.0, estaminaactual - (consumo_estamina * delta))
		else:
			velocity = Vector2.ZERO
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
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
		sprite.play("walk")

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
