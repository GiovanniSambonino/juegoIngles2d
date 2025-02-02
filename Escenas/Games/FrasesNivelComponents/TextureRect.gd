extends TextureRect
const STYLE_WORDS = "res://styles/FrasesNivelCorrectos.tres"
const SCRIPTS_PATH = "res://Escenas/Games/FrasesNivelComponents"
#func _get_drag_data(at_position):
	#return [child
func update_container_button(name):
	var button = Button.new()
	var estilo = preload(STYLE_WORDS)
	button.theme = estilo
	button.text = name
	button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT, Control.PRESET_MODE_KEEP_SIZE)
	var buttonScript = load(SCRIPTS_PATH+"/botonOrdenate.gd")
	button.set_script(buttonScript)
	add_child(button)


	
func _on_timer_timeout(ra):
	# Código que deseas ejecutar después del tiempo
	ra.play("ChangeColor/Change")
	print("Han pasado 2 segundos, ejecutando el código.")
func _on_button_pressed(anim_player):
	anim_player.play("ChangeColor/Change")

func _can_drop_data(at_position, data):
	return true
	
	
func _drop_data(at_position, data):
	var target_button = get_node("../../DisordenateHBoxContainer/"+name)
	if not _is_valid_drop_area(position, data):
		target_button.visible = true
		#var color_rect = ColorRect.new()
		#color_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT, Control.PRESET_MODE_KEEP_SIZE)
		#color_rect.color = Color(0.827,0.09,0.188,0.0)
		#var rectScript = load(SCRIPTS_PATH+"/colorRect.gd")
		#color_rect.set_script(rectScript)
		#get_parent().get_parent().get_parent().add_child(color_rect)
		var color_rect = get_node("../../../ColorRect")
		color_rect.color = Color(0.827,0.09,0.188,0.0)
		var tween = get_tree().create_tween()
		tween.tween_property(color_rect, "color", Color(0.827,0.09,0.188,0.5), 1).set_trans(Tween.TRANS_SINE)
		tween.tween_property(color_rect, "color", Color(0.827,0.09,0.188,0.0), 1).set_trans(Tween.TRANS_SINE)
		tween.play()
	
	else:
		update_container_button(data[0])
		target_button.visible = false
		get_parent().get_parent().get_parent().counter_boxes_correct += 1
		#var color_rect = get_node("../../../ColorRect")
		#color_rect.color = Color(0.122, 0.8, 0.459,0.0)
		#var tween = get_tree().create_tween()
		#tween.tween_property(color_rect, "color", Color(0.122, 0.8, 0.459,0.4), 1).set_trans(Tween.TRANS_SINE)
		#tween.tween_property(color_rect, "color", Color(0.122, 0.8, 0.459, 0.0), 1).set_trans(Tween.TRANS_SINE)
		#tween.play()
	
func _is_valid_drop_area(position, data):
	if data[1] == name:
		return true
	else:
		return false


func set_style(estilo):
	var tema = Theme.new()
	tema.set_stylebox('disabled', "Button", estilo.get_stylebox("normal", "Button"))
	tema.set_stylebox('normal', "Button", estilo.get_stylebox("normal", "Button"))
	#tema.set_stylebox('hover', "Button",  estilo.get_stylebox("hover", "Button"))
	#tema.set_stylebox('pressed', "Button",  estilo.get_stylebox("pressed", "Button"))
	#tema.set_stylebox('focus', "Button",  estilo.get_stylebox("focus", "Button"))
	tema.set_font("font", "Button", estilo.get_font("font", "Button"))
	tema.set_font_size("font_size", "Button", estilo.get_font_size("font_size", "Button"))
	tema.set_color("font_color", "Button", estilo.get_color("font_color", "Button"))
	tema.set_color("font_focus_color", "Button", estilo.get_color("font_focus_color", "Button"))
	#tema.set_color("font_hover_color", "Button", estilo.get_color("font_hover_color", "Button"))
	#tema.set_color("font_hover_pressed_color", "Button", estilo.get_color("font_hover_pressed_color", "Button"))
	#tema.set_color("font_outline_color", "Button", estilo.get_color("font_outline_color", "Button"))
	tema.set_color("font_pressed_color", "Button", estilo.get_color("font_pressed_color", "Button"))
	return tema
	
