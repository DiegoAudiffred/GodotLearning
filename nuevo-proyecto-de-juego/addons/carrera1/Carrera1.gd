extends TrackTemplate

const SPECHAN_SCENE: PackedScene = preload("res://spechan.tscn")
const SUZUKASAN_SCENE: PackedScene = preload("res://susukasan.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	trackDistance = 1000
	curvas = [500.0, 1000.0, 1500.0]
	bajadas = [Vector2(700.0, 900.0), Vector2(1300.0, 1350.0)]
	subidas = [Vector2(1800.0, 2000.0)]
	super._ready() #siempre que sea una clase heredada es recomendable
	#print(lista_participantes)
	#usarla para sobreescribir algunos datos de la clase padre
	
