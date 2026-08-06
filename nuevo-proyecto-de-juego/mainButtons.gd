extends Label

func _ready() -> void:
	pass

func _on_mouse_entered() -> void:
	text = "¡Hazme clic!"
	modulate = Color.GREEN

func _on_mouse_exited() -> void:
	text = "Texto Inicial"
	modulate = Color.WHITE
