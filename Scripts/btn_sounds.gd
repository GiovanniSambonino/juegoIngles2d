extends Control

# Constantes para las rutas de las imágenes del botón de sonido (mute y sonido activado).
const PATH_MUTE_IMAGE = "res://Sprites/buttons/Boton_Silencio.png"
const PATH_MUSIC_IMAGE = "res://Sprites/buttons/Boton_Musica.png"

# Índice del bus de audio maestro.
var music_bus = AudioServer.get_bus_index("Master")

# Referencia al nodo de botón con textura.
@onready var texture_button = $TextureButton

# Función que se llama cuando la escena está lista.
# Verifica si el bus de audio está silenciado o no, y cambia las imágenes del botón en consecuencia.
func _ready():
	# Si el audio no está silenciado, muestra la imagen del botón de música.
	if not AudioServer.is_bus_mute(music_bus):
		texture_button.texture_normal = preload(PATH_MUSIC_IMAGE)
		texture_button.texture_pressed = preload(PATH_MUTE_IMAGE)
	else:
		# Si el audio está silenciado, muestra la imagen del botón de silencio.
		texture_button.texture_normal = preload(PATH_MUTE_IMAGE)
		texture_button.texture_pressed = preload(PATH_MUSIC_IMAGE)

# Función que se ejecuta cuando se presiona el botón.
# Cambia el estado del audio (mute o no mute) al hacer clic en el botón.
func _on_texture_button_pressed():
	# Alterna el estado del bus de audio (silenciado o no) cada vez que se presiona el botón.
	AudioServer.set_bus_mute(music_bus, not AudioServer.is_bus_mute(music_bus))
