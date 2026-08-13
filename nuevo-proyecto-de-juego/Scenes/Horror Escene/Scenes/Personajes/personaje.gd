class_name Personajes
extends Node2D

signal llego_a_caseta
signal se_fue_de_caseta

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var datos: DatosPersonajes


func cargar_datos(p_datos: DatosPersonajes) -> void:
	datos = p_datos
	z_index = 5
	if datos and datos.sprite_frames:
		animated_sprite_2d.sprite_frames = datos.sprite_frames


func entrar_a_escena(posicion_objetivo: Vector2) -> void:
	position = posicion_objetivo + Vector2(-700, 0)
	
	if animated_sprite_2d.sprite_frames.has_animation("arrive"):
		animated_sprite_2d.play("arrive")
		
	var tween = create_tween()
	tween.tween_property(self, "position", posicion_objetivo, 2.0)
	await tween.finished
	
	reproducir_animacion("salute")
	await animated_sprite_2d.animation_finished
	
	#reproducir_animacion("idle")
	#llego_a_caseta.emit()


func salir_de_escena() -> void:
	reproducir_animacion("leave")
	
	var posicion_salida = position - Vector2(600, 0)
	var tween = create_tween()
	tween.tween_property(self, "position", posicion_salida, 2.0)
	await tween.finished
	
	se_fue_de_caseta.emit()
	queue_free()


func reproducir_animacion(nombre_anim: String) -> void:
	if animated_sprite_2d.sprite_frames and animated_sprite_2d.sprite_frames.has_animation(nombre_anim):
		animated_sprite_2d.play(nombre_anim)
