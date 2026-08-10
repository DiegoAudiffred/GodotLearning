extends "res://movementeChar.gd"

func _ready() -> void:
	cargar_datos(2)

func _physics_process(delta: float) -> void:
	super(delta)
