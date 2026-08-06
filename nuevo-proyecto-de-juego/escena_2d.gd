extends Node2D

@onready var spechan = $Spechan
#@onready var label_stamina: Label = $Spechan/label_stamina
@onready var label_stamina: Label = $label_stamina

func _process(delta: float) -> void:
	label_stamina.text = "Stamina: " + str(spechan.get_stamina())
