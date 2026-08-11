extends Camera2D

@export var velocidad: float = 400.0
@export var distancia: float = 1000.0

func _ready() -> void:
	pass

func mover_camara_ida_y_vuelta() -> void:
	var posicion_inicial: Vector2 = global_position
	var posicion_destino: Vector2 = posicion_inicial + Vector2(distancia, 0)
	
	var duracion: float = distancia / velocidad
	
	var tween := create_tween()
	
	tween.tween_property(self, "global_position", posicion_destino, duracion).set_trans(Tween.TRANS_LINEAR)
	
	#tween.tween_property(self, "global_position", posicion_inicial, duracion).set_trans(Tween.TRANS_LINEAR)
