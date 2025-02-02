extends Button
const STYLE_WORDS = "res://styles/FrasesNivelStyleButton.tres"

func _get_drag_data(at_position):
	var button = Button.new()
	button.text = text
	var estilo = preload(STYLE_WORDS)
	var tema = set_style(estilo)
	button.theme = tema
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	var preview = Control.new()
	preview.add_child(button)
	set_drag_preview(preview)
	print(str(button.text))
	
	return [str(button.text), str(name)]
	
	
		
func _drop_data(at_position, data):
	if not _is_valid_drop_area(position, data):
		visible = true
	else:
		visible = false

func set_style(estilo):
	var tema = Theme.new()
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

func _is_valid_drop_area(position, data):
	var target_texture_rect = get_node("../OrdenateHBoxContainer/"+self.name)
	print(target_texture_rect)
	var rect_position = target_texture_rect.global_position
	var rect_size = target_texture_rect.size
	var target_rect = Rect2(rect_position, rect_size)
	if target_rect.has_point(position):
		return true
	else:
		return false
