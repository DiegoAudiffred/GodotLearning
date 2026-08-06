extends CharacterBody2D

var speed: float = 100.0
var estamina: float = 0.0
var nombre_corredora: String = ""

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction != Vector2.ZERO:
		velocity = direction * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)

	_update_animation(direction)

	move_and_slide()

func _update_animation(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		sprite.play("walk")
		if direction.x != 0:
			sprite.flip_h = direction.x > 0
	else:
		sprite.play("walk")

func cargar_datos(id_buscado: String) -> void:
	for chica in DatosUmamusume.LISTA:
		if chica["id"] == id_buscado:
			speed = chica["velocidad"]
			estamina = chica["estamina"]
			nombre_corredora = chica["nombre"]
			modulate = chica["color"]			
			break
