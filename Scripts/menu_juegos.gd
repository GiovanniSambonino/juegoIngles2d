extends Control

# Señal que se emite para actualizar la escena, en este caso el menú principal.
signal update_scene(path)

# Función que se llama cuando el nodo entra en la escena por primera vez.
# Emite una señal para indicar que se debe mostrar el menú principal.
func _ready():
	emit_signal("update_scene", "menu_principal")

# Función que se ejecuta cuando el botón del juego de puzzles es presionado.
# Reproduce el sonido de clic y cambia la escena al nivel de dificultad de Puzzles.
func _on_btn_puzzle_pressed():
	ButtonClick.button_click()
	get_tree().change_scene_to_file("res://Escenas/DificultadOracion1.tscn")

# Función que se ejecuta cuando el botón del juego 'Match It' es presionado.
# Reproduce el sonido de clic y cambia la escena al nivel de dificultad de 'Match It'.
func _on_btn_match_pressed():
	ButtonClick.button_click()
	get_tree().change_scene_to_file("res://Escenas/DificultadUnir1.tscn")

# Función que se ejecuta cuando el botón del juego 'Order It' es presionado.
# Reproduce el sonido de clic y cambia la escena al nivel de dificultad de 'Order It'.
func _on_btn_order_pressed():
	ButtonClick.button_click()
	get_tree().change_scene_to_file("res://Escenas/DificultadPalabra1.tscn")
