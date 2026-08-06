extends Control

# ======================================================
# REFERENCIAS A LOS NODOS DE LA ESCENA
# ======================================================

# Guarda una referencia al Label
@onready var nombre_label: Label = $Label

# Guarda una referencia al TextureRect
@onready var imagen: TextureRect = $TextureRect


# ======================================================
# VARIABLES DE LA CARTA
# ======================================================

# Estas variables guardan la información de la carta.

var nombre : String = "Espada"
var daño : int = 15
var costo : int = 2
var descripcion : String = "Hace daño al enemigo."
var rareza : String = "Común"

# Aquí guardaremos la textura
var textura : Texture2D = null


# ======================================================
# READY
# ======================================================

func _ready():

	print("===================================")
	print("La carta ha sido creada.")
	print("===================================")

	# Actualizamos el texto del Label
	nombre_label.text = nombre

	# Si existe una imagen, la mostramos
	if textura != null:
		imagen.texture = textura

	# Mostramos toda la información en la consola
	mostrar_datos()


# ======================================================
# ESTA FUNCIÓN IMPRIME LOS DATOS
# ======================================================

func mostrar_datos():

	print("Nombre: ", nombre)
	print("Daño: ", daño)
	print("Costo: ", costo)
	print("Rareza: ", rareza)
	print("Descripción: ", descripcion)


# ======================================================
# CAMBIAR EL NOMBRE
# ======================================================

func cambiar_nombre(nuevo_nombre : String):

	nombre = nuevo_nombre

	# Actualiza el Label
	nombre_label.text = nombre

	print("Nuevo nombre:", nombre)


# ======================================================
# CAMBIAR EL DAÑO
# ======================================================

func cambiar_daño(nuevo_daño : int):

	daño = nuevo_daño

	print("Ahora hace", daño, "de daño")


# ======================================================
# RECIBIR UNA IMAGEN
# ======================================================

func cambiar_imagen(ruta : String):

	var nueva_textura = load(ruta)

	if nueva_textura != null:

		textura = nueva_textura

		imagen.texture = textura

		print("Imagen cambiada.")

	else:

		print("No se encontró la imagen.")


# ======================================================
# JUGAR LA CARTA
# ======================================================

func jugar():

	print("------------------------")
	print("Has jugado:", nombre)
	print("Costo:", costo)
	print("Daño:", daño)
	print("------------------------")


# ======================================================
# PROCESS
# ======================================================

func _process(delta):

	# Este código se ejecuta 60 veces por segundo.
	pass


# ======================================================
# INPUT
# ======================================================

func _input(event):

	# Si presionamos la tecla ESPACIO
	if event.is_action_pressed("ui_accept"):

		jugar()

	# Si presionamos la flecha derecha
	if event.is_action_pressed("ui_right"):

		cambiar_daño(daño + 1)

	# Si presionamos la flecha izquierda
	if event.is_action_pressed("ui_left"):

		cambiar_daño(daño - 1)


func _on_button_pressed() -> void:
	pass # Replace with function body.
