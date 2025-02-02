extends Control

# Referencia al nodo VideoStreamPlayer que reproduce el video en la interfaz de instrucciones.
@onready var video_stream_player = $TextureRect/Panel/VideoStreamPlayer

# Función que reanuda el juego.
# Despausa el árbol de nodos (lo que reactiva el juego) y reproduce la animación de "blur" en reversa para quitar el efecto de desenfoque.
# Después, elimina esta escena de instrucciones.
func resume():
	get_tree().paused = false  # Reactivar el juego.
	$AnimationPlayer.play_backwards("blur")  # Quitar el efecto de desenfoque.
	self.queue_free()  # Eliminar la escena de instrucciones de la pantalla.

# Función que pausa el juego.
# Pausa el árbol de nodos (deteniendo todas las operaciones) y activa la animación de desenfoque en la pantalla.
func pause():
	get_tree().paused = true  # Pausar el juego.
	$AnimationPlayer.play("blur")  # Aplicar el efecto de desenfoque.

# Función que se llama cuando el nodo entra en la escena por primera vez.
# Inicia la animación de "RESET", pausa el juego y comienza la reproducción del video.
func _ready():
	$AnimationPlayer.play("RESET")  # Reiniciar la animación.
	pause()  # Pausar el juego para que se enfoque en las instrucciones.
	video_stream_player.play()  # Reproducir el video de instrucciones.

# Función que se ejecuta cuando el botón es presionado.
# Detiene el video y reanuda el juego cuando el jugador ha terminado de ver las instrucciones.
func _on_button_pressed():
	ButtonClick.button_click()  # Efecto de clic del botón.
	video_stream_player.stop()  # Detener el video de instrucciones.
	resume()  # Reanudar el juego y eliminar la escena de instrucciones.
