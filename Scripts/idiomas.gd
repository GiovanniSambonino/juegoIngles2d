extends Control

# Señal que se emite para actualizar la escena, en este caso el menú principal.
signal update_scene(path)

# Función que se llama cuando el nodo entra en la escena por primera vez.
# Emite una señal para indicar que se debe mostrar el menú principal.
func _ready():
	print("ok")
	emit_signal("update_scene", "menu_principal") 
 
# Función que se ejecuta cuando el botón del juego de puzzles es presionado.
# Reproduce el sonido de clic y cambia la escena al nivel de dificultad de Puzzles.
func _on_btn_puzzle_pressed():
	ButtonClick.button_click()
	get_tree().change_scene_to_file("res://Escenas/DificultadOracion1.tscn")

func _on_texturebutton_pressed(): 
	save_language_setting(true)  # Guardar configuración para inglés
	print("Idioma guardado: Inglés") 

func _on_texturebutton2_pressed():
	save_language_setting(false)  # Guardar configuración para español
	print("Idioma guardado: Español")
	
func save_language_setting(is_english: bool):
	var save_data = {"english": is_english} 
	var file = FileAccess.open("res://language_setting.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close() 
	
	
func load_language_setting() -> bool:
	if FileAccess.file_exists("user://language_setting.json"):
		var file = FileAccess.open("user://language_setting.json", FileAccess.READ)
		var json = JSON.new()  # Crear una instancia de JSON
		var parse_result = json.parse(file.get_as_text())  # Analizar el JSON
		file.close() 
		if parse_result.error == OK:
			var save_data = parse_result.result  # Obtener el diccionario
			if "english" in save_data:
				return save_data["english"]  
	return false  # Valor predeterminado si no existe el archivo

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
