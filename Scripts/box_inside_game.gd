extends Node2D

# Rutas de las imágenes del juego
const PATH_IMAGE_GAME = "res://Sprites/images_games/"
const EXTENTION_IMAGE_GAME = ".png"

# Tiempo inicial para el cronómetro (en segundos)
var time_seconds = 120

# Referencias a los nodos de la interfaz de usuario
@onready var title = $Title  # Nodo de título del juego
@onready var difficulty_value = $Difficulty_value  # Nodo que muestra el valor de la dificultad
@onready var level_value = $HBoxContainer2/Level_value  # Nodo que muestra el nivel actual
@onready var image = $image  # Nodo de imagen dentro del juego
@onready var sentense = $Sentense  # Nodo de frase (que se utiliza cuando se muestra una oración)
@onready var word = $word  # Nodo de palabra
@onready var phrase_text = $phrase_text  # Nodo que muestra texto
@onready var temporizador = $Temporizador  # Nodo de temporizador
@onready var timer = $Temporizador/Timer  # Nodo de Timer que gestiona el cronómetro

func _ready():
	# Al inicio se ocultan ciertos elementos y se detiene el cronómetro
	word.visible = false
	sentense.visible = false
	phrase_text.visible = false
	temporizador.visible = false
	timer.stop()

	# Conectar señales para actualizar el título, dificultad, nivel, y manejar el temporizador
	get_parent().connect("update_title", Callable(self, "_on_update_title"))
	get_parent().connect("update_difficulty", Callable(self, "_on_update_difficulty"))
	get_parent().connect("update_level", Callable(self, "_on_update_level"))
	get_parent().connect("set_timer", Callable(self, "_on_set_timer"))
	get_parent().connect("set_visible_word", Callable(self, "_on_set_visible_word"))

# Función para actualizar el título del juego
func _on_update_title(new_title):
	title.text = new_title
	
# Función para actualizar el valor de la dificultad
func _on_update_difficulty(new_difficulty):
	difficulty_value.text = new_difficulty
	print(new_difficulty)
	
# Función para actualizar el nivel del juego
func _on_update_level(new_level):
	level_value.text = new_level
	
# Función para actualizar la imagen del juego
func _on_uptate_imagen_game(new_image):
	var url_image = PATH_IMAGE_GAME + new_image + EXTENTION_IMAGE_GAME
	image.texture = load(url_image)

# Función para ocultar la imagen del juego
func _on_set_not_visible_image():
	image.visible = false
	
# Función para mostrar una frase o oración en el juego
func _on_set_visible_sentence(new_sentence):
	sentense.visible = true
	phrase_text.visible = true
	phrase_text.text = new_sentence
	
# Función para mostrar una palabra en el juego
func _on_set_visible_word(new_word):
	word.visible = true
	phrase_text.visible = true
	phrase_text.add_theme_font_size_override("font_size", 50)
	phrase_text.text = new_word
	
# Función que activa el cronómetro del juego
func _on_set_timer():
	temporizador.visible = true
	timer.start()

# Función que se ejecuta cuando el cronómetro llega a su fin
func _on_timer_timeout():
	if time_seconds > 0:
		time_seconds -= 1
	else:
		get_parent().lose()  # Si el tiempo se acaba, se llama a la función perder
	temporizador.text = str(time_seconds)

# Función que se ejecuta al presionar el botón de inicio (btn_home)
func _on_btn_home_pressed():
	ButtonClick.button_click()
	get_tree().change_scene_to_file("res://Escenas/menu_juegos.tscn")
	
# Función que se ejecuta al presionar el botón de ayuda (btn_help)
func _on_btn_help_pressed():
	ButtonClick.button_click()
	get_tree().change_scene_to_file("res://Escenas/DificultadUnir1.tscn")

# Función que se ejecuta al presionar el botón de instrucciones (btn_instructions)
func _on_btn_instructions_pressed():
	ButtonClick.button_click()
	var padre = get_parent()
	if padre and padre.has_method("_dar_pista"):
		padre._dar_pista()
	else:
		print("No se encontró la función en el nodo padre.")
