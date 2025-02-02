extends Control

func resume():
	get_tree().paused = false 
	$AnimationPlayer.play_backwards("blur")
func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
func testEsc():
	if Input.is_action_just_pressed("esc") and  get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("esc") and  get_tree().paused == true:
		resume()

func _ready():
	$AnimationPlayer.play("RESET")
	
func _process(delta):
	testEsc()



func _on_texture_button_2_pressed():
	ButtonClick.button_click()
	get_tree().paused = false 
	get_tree().change_scene_to_file("res://Escenas/menu_principal.tscn") 


func _on_texture_button_pressed():
	ButtonClick.button_click()
	get_tree().paused = false 
	get_tree().change_scene_to_file("res://Escenas/SeleccionOracion.tscn") 
