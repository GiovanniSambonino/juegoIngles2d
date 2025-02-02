extends Control


const STYLE_WORDS = "res://styles/FrasesNivelStyleButton.tres"
const SCRIPTS_PATH = "res://Escenas/Games/FrasesNivelComponents"
const url_fondo = "res://Sprites/global/Tabla.png"
var pantallaVictoria = preload("res://Escenas/PantallaVictoria.tscn")
var instance
#Signals
signal update_title(new_title)
signal update_difficulty(new_difficulty)
signal update_level(new_level)
signal set_visible_sentence(new_sentence)
signal uptate_imagen_game(new_image)
signal set_timer()

@onready var d_hbox = $Box_inside_game/DisordenateHBoxContainer
@onready var o_hbox = $Box_inside_game/OrdenateHBoxContainer
var counter_boxes_correct: int = 0
var total_boxes_correct: int = 10
var start_texture_rect: TextureRect = null
var palabraEsp = ["El esta jugando futbol", "Ella esta bebiendo cafe dulce"]
var cadenas = [["He is", "playing", "football"], ["She", "is", "drinking", "sweet", "coffee"]]
var cadenasOrdenadas = [["He is", "playing", "football"], ["She", "is", "drinking", "sweet", "coffee"]]
# Called when the node enters the scene tree for the first time.

func correct_color_rect():
	var color_rect = ColorRect.new()
	color_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT, Control.PRESET_MODE_KEEP_SIZE)
	color_rect.color = Color(0.5,0.5,0.5,0.0)
	add_child(color_rect)
	
func incorrect_color_rect():
	var color_rect = ColorRect.new()
	color_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT, Control.PRESET_MODE_KEEP_SIZE)
	color_rect.color = Color(1.0,0.5,0.5,0.0)
	var rectScript = load(SCRIPTS_PATH+"/botonTextura.gd")
	rectScript.set_script(rectScript)
	add_child(color_rect)

func victory():
	instance.position = Vector2(1000,0)
	add_child(instance)
	while(instance.position.x > 0):
		await get_tree().create_timer(0.000000001).timeout
		instance.position.x-=50

func _ready():
	counter_boxes_correct = 0
	var random_index = randi() % cadenas.size()
	total_boxes_correct = cadenas[random_index].size()
	instance = pantallaVictoria.instantiate()
	emit_signal("update_title", "Puzzle")
	emit_signal("update_difficulty", "Easy")
	emit_signal("update_level", "1")
	emit_signal("set_visible_sentence", palabraEsp[random_index])
	emit_signal("uptate_imagen_game", "puzzle/futbol1")
	emit_signal("set_timer")
	# Seleccionar un índice aleatorio

	cargar_etiquetas_con_fondo(cadenas, random_index)
	#button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#var anim_player = AnimationPlayer.new()
	#anim_player.set_root("../Box_inside_game/DisordenateHBoxContainer/ButtonP")
	#anim_player.name = "AnimationPlayer"
	#var animation = Animation.new()
	#var texture_track_index = animation.add_track(Animation.TYPE_VALUE)
	#animation.track_set_interpolation_type(texture_track_index, Animation.INTERPOLATION_LINEAR)
	#animation.track_set_path(texture_track_index, ":theme_override_styles/normal:modulate_color")  
	#animation.track_insert_key(texture_track_index, 0.0, Color(1.0,1.0,1.0,1.0))  # Color inicial
	#animation.track_insert_key(texture_track_index, 1.0, Color(0.5,0.5,0.5,1.0))
	#var anim_library = AnimationLibrary.new()
	#anim_library.add_animation("Change", animation)
	#anim_player.add_animation_library("ChangeColor", anim_library)
	#button.add_child(anim_player)
	#var buttonScript = load(SCRIPTS_PATH+"/botonOrdenate.gd")
	#button.set_script(buttonScript)
	#ap.play("ChangeColor/Change")# Color final, en el segundo 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(counter_boxes_correct == total_boxes_correct):
		victory()
		

func cargar_etiquetas_con_fondo(cadenas: Array, index: int):
	cadenas[index].shuffle()
	var x=0
	for cadena in cadenas[index]:
		#var containerCadena = TextureRect.new()
		#containerCadena.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		#containerCadena.custom_minimum_size = Vector2(225,100)
		#containerCadena.texture = load(url_fondo)
		#containerCadena.axis_stretch_horizontal =NinePatchRect.AXIS_STRETCH_MODE_STRETCH
		#containerCadena.axis_stretch_vertical =NinePatchRect.AXIS_STRETCH_MODE_STRETCH
		#containerCadena.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		#containerCadena.size_flags_horizontal = Control.SIZE_SHRINK_CENTER 
		#containerCadena.clip_contents = false
		var posicionCadena = cadenasOrdenadas[index].find(cadena)
		
		var button = Button.new()
		button.text = cadena	
		var estilo = preload(STYLE_WORDS)
		var tema = set_style(estilo)
		button.theme = tema		
		button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		button.name = "t_"+str(posicionCadena)
		var buttonScript = load(SCRIPTS_PATH+"/botonTextura.gd")
		button.set_script(buttonScript)
		
	# Ajustar las propiedades de anchor para centrar el botón
		#button.set_anchors_and_offsets_preset(Control.PRESET_CENTER, Control.PRESET_MODE_KEEP_SIZE)
		d_hbox.add_child(button)
		var ordenadaCadena = TextureRect.new()
		ordenadaCadena.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		ordenadaCadena.custom_minimum_size = Vector2(225,100)
		ordenadaCadena.name = "t_"+str(x)
		var textureScript = load(SCRIPTS_PATH+"/TextureRect.gd")
		ordenadaCadena.set_script(textureScript)
		#var panelOrdenada = Panel.new()
		#panelOrdenada.mouse_filter =Control.MOUSE_FILTER_IGNORE
		#panelOrdenada.show_behind_parent = true
		#ordenadaCadena.add_child(panelOrdenada)
		ordenadaCadena.texture = load(url_fondo)
		
		o_hbox.add_child(ordenadaCadena)
		x+=1

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

func _on_btn_go_back_pressed():
	ButtonClick.button_click()
	get_tree().change_scene_to_file("res://Escenas/menu_juegos.tscn")
