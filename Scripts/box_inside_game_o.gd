extends Node2D

const PATH_IMAGE_GAME = "res://Sprites/images_games/"
const EXTENTION_IMAGE_GAME = ".png"

var time_seconds = 120

@onready var title = $Title
@onready var difficulty_value = $Difficulty_value
@onready var level_value = $HBoxContainer2/Level_value
@onready var image = $image
#@onready var sentence = $TextureRect2/Sentence
@onready var sentense = $Sentense
@onready var word = $word
@onready var phrase_text = $phrase_text
@onready var temporizador = $Temporizador
@onready var timer = $Temporizador/Timer

func _ready():
	word.visible = false
	sentense.visible = false
	phrase_text.visible = false
	temporizador.visible = false
	timer.stop()
	get_parent().connect("update_title", Callable(self, "_on_update_title"))
	get_parent().connect("update_difficulty", Callable(self, "_on_update_difficulty"))
	get_parent().connect("update_level", Callable(self, "_on_update_level"))
	get_parent().connect("set_timer", Callable(self, "_on_set_timer"))
	#get_parent().connect("uptate_imagen_game", Callable(self, "_on_uptate_imagen_game"))
#	get_parent().connect("set_not_visible_image", Callable(self, "_on_set_not_visible_image"))
#	get_parent().connect("set_visible_sentence", Callable(self, "_on_set_visible_sentence"))
	get_parent().connect("set_visible_word", Callable(self, "_on_set_visible_word"))

func _on_update_title(new_title):
	title.text = new_title
	
func _on_update_difficulty(new_difficulty):
	difficulty_value.text = new_difficulty
	print(new_difficulty)
	
func _on_update_level(new_level):
	level_value.text = new_level
	
func _on_uptate_imagen_game(new_image):
	print(new_image)
	var url_image = PATH_IMAGE_GAME + new_image + EXTENTION_IMAGE_GAME
	image.texture = load(url_image)

func _on_set_not_visible_image():
	image.visible = false
	
func _on_set_visible_sentence(new_sentence):
	sentense.visible = true
	phrase_text.visible = true
	phrase_text.text = new_sentence
	
func _on_set_visible_word(new_word):
	word.visible = true
	phrase_text.visible = true
	phrase_text.add_theme_font_size_override("font_size", 40)
	phrase_text.text = new_word
	
func _on_set_timer():
	temporizador.visible = true
	timer.start()

func _on_timer_timeout():
	if time_seconds > 0:
		time_seconds -= 1
	else:
		#get_tree().change_scene_to_file("res://Escenas/menu_juegos.tscn")
		get_parent().lose()
	temporizador.text = str(time_seconds)

func _on_btn_home_pressed():
	ButtonClick.button_click()
	get_tree().change_scene_to_file("res://Escenas/menu_juegos.tscn")
	

func _on_btn_instructions_pressed():
	ButtonClick.button_click()
	var padre = get_parent()
	if padre and padre.has_method("_dar_pista"):
		padre._dar_pista()
	else:
		print("No se encontró la función en el nodo padre.")


func _on_btn_levels_pressed():
	ButtonClick.button_click()
	get_tree().change_scene_to_file("res://Escenas/DificultadPalabra1.tscn")
	pass # Replace with function body.
