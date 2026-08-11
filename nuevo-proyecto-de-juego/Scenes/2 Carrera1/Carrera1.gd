extends TrackTemplate

#const SPECHAN_SCENE: PackedScene = preload("res://spechan.tscn")
#const SUZUKASAN_SCENE: PackedScene = preload("res://susukasan.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	trackDistance = 1000
	#subidas = [Vector2(1000.0, 1500.0)]
	#bajadas = [Vector2(1501.0, 2000.0)]
	#curvas = [Vector2(2001.0, 2500.0)]
	super._ready() #siempre que sea una clase heredada es recomendable
	#print(lista_participantes)
	#usarla para sobreescribir algunos datos de la clase padre
	
