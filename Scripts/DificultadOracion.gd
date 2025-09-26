extends Node2D

signal update_scene(path)
# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("update_scene", "menu_juegos")
	$TextureButton2.disabled = true
	$TextureButton3.disabled = true
	verificar_progreso(Global.rutaArchivos+"/Progress/progressMinigames.dat")

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta):
	pass
	
func actualizar_candados(progreso, minigame):
	if(progreso[minigame]["medium"] && progreso[minigame]["firstMedium"] == false):
		$Sprite2D.visible = false
		$TextureButton2.disabled = false
		$TextureButton2.mouse_default_cursor_shape = $TextureButton2.CURSOR_POINTING_HAND
	if(progreso[minigame]["hard"] && progreso[minigame]["firstHard"] == false):
		$Sprite2D3.visible=false
		$TextureButton3.disabled = false
		$TextureButton3.mouse_default_cursor_shape = $TextureButton3.CURSOR_POINTING_HAND
	
	if(progreso[minigame]["medium"] && progreso[minigame]["firstMedium"]):
		$Sprite2D/AnimationPlayer.play("Unlock")
		await $Sprite2D/AnimationPlayer.animation_finished
		$TextureButton2.disabled = false
		$TextureButton2.mouse_default_cursor_shape = $TextureButton2.CURSOR_POINTING_HAND
		progreso[minigame]["firstMedium"] = false
		actualizar_archivo(progreso, Global.rutaArchivos+"/Progress/progressMinigames.dat")
		
	elif(progreso[minigame]["hard"] && progreso[minigame]["firstHard"]):
		$Sprite2D3/AnimationPlayer.play("Unlock")
		await $Sprite2D3/AnimationPlayer.animation_finished
		$TextureButton3.disabled = false	
		$TextureButton3.mouse_default_cursor_shape = $TextureButton3.CURSOR_POINTING_HAND
		progreso[minigame]["firstHard"] = false
		actualizar_archivo(progreso, Global.rutaArchivos+"/Progress/progressMinigames.dat")
	

		 
func actualizar_archivo(progress, path):
	if DirAccess.remove_absolute(path) == OK:	 
			print("Archivo existente borrado.")
			var new_file = FileAccess.open(path ,FileAccess.WRITE)
			new_file.store_var(progress)
			new_file = null
	else:
			print("Error al intentar borrar el archivo.")
func verificar_progreso(path):
	if FileAccess.file_exists(path):  # Verifica si el archivo existe  
		print("ARCHIVO EXISTE")
		var file = FileAccess.open(path, FileAccess.READ) # Abre el archivo en modo lectura
		var progreso = file.get_var()
		file = null
		actualizar_candados(progreso, "puzzle")
		
		
	else:
		print("ARCHIVO NO EXISTE")
		var content = {
			"puzzle":{
				"easy":true,
				"medium":false,
				"hard":false,
				"firstMedium":false,
				"firstHard":false,				
			},
			"match":{
				"easy":true,
				"medium":false,
				"hard":false,
				"firstMedium":false,
				"firstHard":false,
			},
			"order":{
				"easy":true,
				"medium":false,
				"hard":false,
				"firstMedium":false,
				"firstHard":false,				
			},
		}
		var file = FileAccess.open(path ,FileAccess.WRITE)
		file.store_var(content)
		file = null
func _on_btn_go_back_pressed():
	get_tree().change_scene_to_file("res://Escenas/menu_juegos.tscn")


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Escenas/SeleccionOracion.tscn")


func _on_texture_button_pressed():
	ButtonClick.button_click()
	Score.actualDifficult = Score.difficult["easy"]
	get_tree().change_scene_to_file("res://Escenas/Games/FrasesNivel1.tscn")


func _on_texture_button_2_pressed():
	ButtonClick.button_click()
	Score.actualDifficult = Score.difficult["medium"]
	get_tree().change_scene_to_file("res://Escenas/Games/FrasesNivel2.tscn")    
	
func _on_texture_button_3_pressed():
	ButtonClick.button_click()
	Score.actualDifficult = Score.difficult["hard"]
	get_tree().change_scene_to_file("res://Escenas/Games/FrasesNivel3.tscn") 
