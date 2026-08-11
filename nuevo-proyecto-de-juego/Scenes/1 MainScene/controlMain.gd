extends Control
@onready var titulo: Label = $Titulo


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func _on_titulo_mouse_entered() -> void:
	titulo.text = "¡Hazme clic!"
	titulo.modulate = Color.GREEN

func _on_titulo_mouse_exited() -> void:
	titulo.text = "Texto Inicial"
	titulo.modulate = Color.WHITE	


func _on_boton_pressed() -> void:
	var pista := preload("res://Scenes/2 Carrera1/Carrera1.tscn").instantiate()

	var spechan := preload("res://addons/Umas/Spechan/Spechan.tscn")
	var susukasan := preload("res://addons/Umas/Susukasan/susukasan.tscn")

	var seleccionadas: Array[PackedScene] = [spechan]#,susukasan ]
	pista.cargar_participantes(seleccionadas)

	get_tree().root.add_child(pista) #agrega el nodo pista
	get_tree().current_scene = pista #nueva escena
	queue_free() #destruye el menú anterior para que los elementos gráficos no se encimen.

	#var goldship := preload("res://goldshisan.tscn")
	#var mcqueen := preload("res://mcqueensan.tscn")
	#var seleccionadas: Array[PackedScene] = [spechan, susukasan]
   	#llama al metodo de la pista para cargar #a las corredorasque enviamos en la lista
	
	#================Llamar nodo y agregarlo a la escena actual===============
	#var pista := preload("res://addons/carrera1/Carrera1.tscn").instantiate()
	#pista.cargar_participantes(seleccionadas)
	#get_tree().root.add_child(pista)#solo admite nodos

	#get_tree().change_scene_to_file("res://Escena2D.tscn") #solo admite strings
	#==========================================================================
