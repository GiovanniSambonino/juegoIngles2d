extends Control

# Señal que se emite para actualizar la escena, en este caso el menú principal.
signal update_scene(path)

# Función que se llama cuando el nodo entra en la escena por primera vez.
# Emite una señal para indicar que se debe mostrar el menú principal.
func _ready():
	emit_signal("update_scene", "menu_principal")
	# Deshabilitamos Random y mostramos candado al inicio
	$btn_random.disabled = true
	$btn_random.mouse_default_cursor_shape = Control.CURSOR_ARROW
	$candado.visible = true
	verificar_progreso(Global.rutaArchivos + "/Progress/progressMinigames.dat")
	
func actualizar_candados(progreso):
	# Solo desbloqueamos Random si se cumplen los requisitos
	if progreso["puzzle"]["hard"] and progreso["match"]["hard"] and progreso["order"]["hard"]:
		
		# Solo reproducir animación si firstUnlock es true
		if $candado.visible and progreso["random"]["firstUnlock"]:
			$candado/AnimationPlayer.play("Unlock")
			await $candado/AnimationPlayer.animation_finished
			$candado.visible = false

			# Marcar como desbloqueado permanentemente
			progreso["random"]["firstUnlock"] = false
			actualizar_archivo(progreso, Global.rutaArchivos + "/Progress/progressMinigames.dat")
		else:
			# Ya fue desbloqueado antes, solo ocultamos candado si sigue visible
			$candado.visible = false

		# Habilitamos el botón Random siempre que se cumplan los requisitos
		$btn_random.disabled = false
		$btn_random.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


		
func verificar_progreso(path):
	if FileAccess.file_exists(path):  
		print("ARCHIVO EXISTE")
		var file = FileAccess.open(path, FileAccess.READ) 
		var progreso = file.get_var()
		file = null
		# Inicializar random si no existe
		if not progreso.has("random"):
			progreso["random"] = {"firstUnlock": true}
		actualizar_candados(progreso)
	else:
		print("ARCHIVO NO EXISTE")
		var content = {
			"puzzle": {
				"easy": true,
				"medium": false,
				"hard": false,
				"firstMedium": false,
				"firstHard": false
			},
			"match": {
				"easy": true,
				"medium": false,
				"hard": false,
				"firstMedium": false,
				"firstHard": false
			},
			"order": {
				"easy": true,
				"medium": false,
				"hard": false,
				"firstMedium": false,
				"firstHard": false
			},
			"random": {
				"firstUnlock": true
			}
		}
		var file = FileAccess.open(path ,FileAccess.WRITE)
		file.store_var(content)
		file = null
		actualizar_candados(content)
		
func actualizar_archivo(progress, path):
	var file = FileAccess.open(path ,FileAccess.WRITE)
	file.store_var(progress)
	file.close()

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

# Función que se ejecuta cuando el botón del modo random es presionado.
# Reproduce el sonido de clic y cambia la escena al nivel de dificultad de 'Order It'.
func _on_btn_random_pressed():
	ButtonClick.button_click()
	#await get_tree().create_timer(0.05).timeout
	DificultadRandom.load_next_random_level()
