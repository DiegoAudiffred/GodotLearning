extends Node2D

@onready var label_stamina: Label = $label_stamina
@onready var option_button: OptionButton = $OptionButton

var corredora_actual: Node2D = null

func _ready() -> void:
	_poblar_option_button()
	_inicializar_corredoras()
	_actualizar_corredora_activa(1)

func _process(delta: float) -> void:
	if corredora_actual and corredora_actual.has_method("get_stamina"):
		label_stamina.text = "Stamina: " + str(corredora_actual.get_stamina())

func _poblar_option_button() -> void:
	option_button.clear()
	for chica in DatosUmamusume.LISTA:
		option_button.add_item(chica["nombre"], chica["id"])

func _inicializar_corredoras() -> void:
	for hijo in get_children():
		if hijo.has_method("get_id"):
			hijo.visible = false
			hijo.set_physics_process(false)
			if hijo.has_node("CollisionShape2D"):
				hijo.get_node("CollisionShape2D").set_deferred("disabled", true)

func _on_option_button_item_selected(index: int) -> void:
	var selected_id: int = option_button.get_item_id(index)
	_actualizar_corredora_activa(selected_id)

func _actualizar_corredora_activa(target_id: int) -> void:
	var nueva_posicion: Vector2 = Vector2.ZERO
	
	if corredora_actual:
		nueva_posicion = corredora_actual.global_position
		corredora_actual.visible = false
		corredora_actual.set_physics_process(false)
		if corredora_actual.has_node("CollisionShape2D"):
			corredora_actual.get_node("CollisionShape2D").set_deferred("disabled", true)

	for hijo in get_children():
		if hijo.has_method("get_id") and hijo.get_id() == target_id:
			if corredora_actual:
				hijo.global_position = nueva_posicion
			
			corredora_actual = hijo
			corredora_actual.visible = true
			corredora_actual.set_physics_process(true)
			if corredora_actual.has_node("CollisionShape2D"):
				corredora_actual.get_node("CollisionShape2D").set_deferred("disabled", false)
			break
