extends Node

# Señal que se emite para actualizar la escena, en este caso el menú principal.
signal update_scene(path)

# Diccionario con todas las rutas de niveles organizadas por juego y dificultad
var game_levels = {
	"puzzle": {
		"easy": "res://Escenas/Games/FrasesNivel1.tscn",
		"medium": "res://Escenas/Games/FrasesNivel2.tscn",
		"hard": "res://Escenas/Games/FrasesNivel3.tscn"
	},
	"match": {
		"easy": "res://Escenas/Games/UnirFacil1.tscn",
		"medium": "res://Escenas/Games/UnirMedium.tscn",
		"hard": "res://Escenas/Games/UnirHard.tscn"
	},
	"order": {
		"easy": "res://Escenas/Games/OrderEasy1.tscn",
		"medium": "res://Escenas/Games/OrderMedium.tscn",
		"hard": "res://Escenas/Games/OrderHard.tscn"
	}
}

# Función que se llama cuando el nodo entra en la escena por primera vez.
func _ready():
	emit_signal("update_scene", "menu_principal")

# Función para seleccionar un nivel aleatorio
func load_random_level():
	ButtonClick.button_click()
	
	# Obtener una lista de todos los juegos
	var games = game_levels.keys()
	var random_game = games[randi() % games.size()]
	
	# Obtener una lista de todas las dificultades del juego seleccionado
	var difficulties = game_levels[random_game].keys()
	var random_difficulty = difficulties[randi() % difficulties.size()]
	
	# Establecer la dificultad actual en el Score
	Score.actualDifficult = Score.difficult[random_difficulty]
	
	# Obtener la ruta del nivel aleatorio
	var level_path = game_levels[random_game][random_difficulty]
	
	# Cambiar a la escena
	get_tree().change_scene_to_file(level_path)

# Nueva función para el botón de nivel aleatorio
func _on_btn_random_pressed():
	load_random_level()

# Funciones originales del selector de juegos
func _on_btn_puzzle_pressed():
	ButtonClick.button_click()
	get_tree().change_scene_to_file("res://Escenas/DificultadOracion1.tscn")

func _on_btn_match_pressed():
	ButtonClick.button_click()
	get_tree().change_scene_to_file("res://Escenas/DificultadUnir1.tscn")

func _on_btn_order_pressed():
	ButtonClick.button_click()
	get_tree().change_scene_to_file("res://Escenas/DificultadPalabra1.tscn")

# Funciones originales de dificultad para Match It (Unir)
func _on_texture_button_pressed():
	ButtonClick.button_click()
	Score.actualDifficult = Score.difficult["easy"] 
	get_tree().change_scene_to_file("res://Escenas/Games/UnirFacil1.tscn")

func _on_texture_button_2_pressed():
	ButtonClick.button_click()
	Score.actualDifficult = Score.difficult["medium"]
	get_tree().change_scene_to_file("res://Escenas/Games/UnirMedium.tscn")

func _on_texture_button_3_pressed():
	ButtonClick.button_click()
	Score.actualDifficult = Score.difficult["hard"]
	get_tree().change_scene_to_file("res://Escenas/Games/UnirHard.tscn")
