class_name DatosPersonajes
extends Resource

@export_group("Visual")
@export var sprite_frames: SpriteFrames

@export_group("Datos del Ticket")
@export var tarifa_requerida: float = 10.0
@export var dinero_entregado: float = 10.0
@export var tiene_boleto: bool = true
@export var fecha_boleto_valida: bool = true
@export var id_boleto: String = "12345"
@export var id_es_valido: bool = true
@export var destino_solicitado: String = "Zona A"
@export var destino_en_boleto: String = "Zona A"

@export_group("Anomalías y Estado")
@export var es_impostor: bool = false
@export var foto_coincide: bool = true
@export var rasgo_humano: bool = true
@export var sombra_presente: bool = true
@export var nivel_nerviosismo: float = 0.0
@export var esta_buscado: bool = false
@export var respuesta_sospechosa: bool = false
