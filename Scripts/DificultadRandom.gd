extends Node

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

# Cola de niveles aleatorios (ahora incluye todas las dificultades)
var random_levels_queue: Array = []

func _ready():
	emit_signal("update_scene", "menu_principal")

# Construye la cola con TODOS los niveles (easy, medium, hard) y mezcla
func build_random_queue_all():
	random_levels_queue.clear()
	for game in game_levels.keys():
		for difficulty in game_levels[game].keys():
			random_levels_queue.append({
				"path": game_levels[game][difficulty],
				"difficulty": difficulty
			})
	random_levels_queue.shuffle()

# Cargar el siguiente nivel de la cola
func load_next_random_level():
	if random_levels_queue.is_empty():
		build_random_queue_all()
	if not random_levels_queue.is_empty():
		var level_data = random_levels_queue.pop_front()
		# Establecer dificultad en Score según el nivel seleccionado
		Score.actualDifficult = Score.difficult[level_data["difficulty"]]
		get_tree().change_scene_to_file(level_data["path"])

# Función para el botón de modo random (ahora puede ser de cualquier dificultad)
func _on_btn_random_pressed():
	ButtonClick.button_click()
	build_random_queue_all()
	load_next_random_level()

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
