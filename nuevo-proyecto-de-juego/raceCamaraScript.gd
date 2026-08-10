extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
#func mover_camara_ida_y_vuelta() -> void:
#var posicion_inicial: Vector2 = race_camera.get_screen_center_position()
#var posicion_destino: Vector2 = posicion_inicial + Vector2(trackDistance, 0)
#var duracion: float = trackDistance / velocidadCamara
#var tween := create_tween()
#tween.tween_property(self, "global_position", posicion_destino, duracion).set_trans(Tween.TRANS_LINEAR)


#tween.tween_property(self, "global_position", posicion_inicial, duracion).set_trans(Tween.TRANS_LINEAR) 
