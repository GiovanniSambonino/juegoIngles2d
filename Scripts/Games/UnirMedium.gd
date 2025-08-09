extends Node2D

# Señales que se emiten para actualizar diferentes aspectos de la escena, título, dificultad, nivel y visibilidad de las imágenes.
signal update_scene(path)
signal update_title(new_title)
signal set_timer()
signal update_difficulty(new_difficulty)
signal update_level(new_level)
signal set_not_visible_image()
var ejecutablePath = Global.rutaArchivos

# Variables para el control del nivel, dificultad, título, rondas, y otras propiedades del juego.
var level = 1
var difficulty = 'medium'
var title = "match it"
var rondas = 5  # Número total de rondas.
var numeroRondas = 1  # Ronda actual.
var ganoRonda = false  # Indica si se ha ganado una ronda.

# Variables para precisión, velocidad, y cronómetro.
var precisionMinima = 20
var precisionActual = 100
var velocidad = 20
var valorNivel = 100
var tiempoCronometro = 90  # Tiempo en segundos del cronómetro.

# Variables para las imágenes seleccionadas.
var selected_image: Node2D = null  # Imagen actualmente seleccionada.
# Rutas de las imágenes utilizadas en el juego.
#var image1 = "res://Sprites/images_games/match/easy/Iguana.png"
#var image2 = "res://Sprites/images_games/match/easy/Squirrel.png"
#var image3 = "res://Sprites/images_games/match/easy/Woodpecker.png"
#var image4 = "res://Sprites/images_games/match/easy/Ant-eater.png"
#var image5 = "res://Sprites/images_games/match/easy/Baltimore oriole.png"
#var image6 = "res://Sprites/images_games/match/easy/Cricket.png"
#var image7 = "res://Sprites/images_games/match/easy/Gray-backed Hawk.png"
#var image8 = "res://Sprites/images_games/match/easy/Great white heron.png"
#var image9 = "res://Sprites/images_games/match/easy/Howler monkey.png"
#var image10 = "res://Sprites/images_games/match/easy/Red-crowned parrot.png"
#var image11 = "res://Sprites/images_games/match/easy/Sloth.png"
#var image12 = "res://Sprites/images_games/match/easy/Turquoise Butterfly.png"

var animals = {}
var images = []
var names = []
var shufflednames= []
# Referencias a nodos en la escena.
@onready var box_imagen_match = $Box_imagen_match
@onready var box_imagen_match_2 = $Box_imagen_match2
@onready var box_imagen_match_3 = $Box_imagen_match3
@onready var box_texto_match = $Box_texto_match
@onready var box_texto_match_2 = $Box_texto_match2
@onready var box_texto_match_3 = $Box_texto_match3
@onready var hints_panel = $HintsPanel
@onready var hints_label = $HintsPanel/Label


# Variables para controlar el estado de las instancias en la escena.
var instantiated: bool = false
var gano: bool = false
var pantallaVictoria = preload("res://Escenas/PantallaVictoria.tscn")
var instance
var pantallaAcaboTiempo = preload("res://Escenas/NivelFinalizado.tscn")
var difuminado = preload("res://Piezas/ColorRectDifuminado.tscn")
var instanceAcaboTiempo
var instantiatedAcaboTiempo = false
var instanceDifuminado
var instantiatedDifuminado = false

# Método llamado cuando el nodo entra en la escena por primera vez.
func _ready():
	load_medium_mode_animals()
	assign_images_and_names()
	# Emitir señales para inicializar los parámetros del juego.
	emit_signal("set_timer")
	emit_signal("update_scene", "menu_juegos")
	emit_signal("update_title", title)
	setDifficultTitle()
	emit_signal("update_level", str(level))
	emit_signal("set_not_visible_image")

	# Instanciar escenas necesarias para el juego.
	instance = pantallaVictoria.instantiate()
	instantiated = true
	instanceAcaboTiempo = pantallaAcaboTiempo.instantiate()
	instantiatedAcaboTiempo = true
	instanceDifuminado = difuminado.instantiate()
	instantiatedDifuminado = true

	# Inicializar el tiempo del cronómetro y comenzar el juego.
	tiempoCronometro = $Box_inside_game2.time_seconds
	hints_panel.visible = false
	iniciar_juego()

# Load the data from MatchIt.json for easy mode
func load_medium_mode_animals():
	var file = FileAccess.open("res://JsonJuegos/MatchIt.json", FileAccess.READ)
	if file:
		var data = file.get_as_text()  # Read the JSON content
		var json_result = JSON.parse_string(data)  # Parse the JSON string
		file.close()

		if typeof(json_result) == TYPE_DICTIONARY and "medium" in json_result:
			animals = json_result["medium"].duplicate(true)
		else:
			print("Error parsing JSON:", json_result.error_string)
	else:
			print("MatchIt.json not found at res://JsonJuegos/MatchIt.json")

func assign_images_and_names():
	var keys = animals.keys()
	randomize()  # Ensure random order each game

	if keys.size() < 15:
		print("Not enough animals left for a round.")
		return

# Pick 15 unique animals for the round
	for i in range(15):
		var selected_key = keys.pop_front()  # Remove the key to avoid repetition
		images.append(animals[selected_key])
		names.append(selected_key)
		animals.erase(selected_key)  # Remove from the pool

func _process(_delta):
	if(instantiated):
		# Verificar si se ha ganado una ronda o si se ha completado el juego.
		if(box_texto_match.is_matched() and box_texto_match_2.is_matched() and
		box_texto_match_3.is_matched() and numeroRondas == rondas+1 and !gano):
			gano = true
			victory()  # Llamar al método de victoria si se completaron todas las rondas.
		elif (box_texto_match.is_matched() and box_texto_match_2.is_matched() and
		 box_texto_match_3.is_matched() and numeroRondas < rondas+1 and !ganoRonda and !gano):
			ganoRonda = true
			numeroRondas+=1  # Incrementar el número de rondas.
			if(numeroRondas <= rondas):
				ronda_win()

# Método para establecer el texto de dificultad
func setDifficultTitle():
	match Score.actualDifficult:
		Score.difficult["easy"]:
			emit_signal("update_difficulty", "Easy")
		Score.difficult["medium"]:
			emit_signal("update_difficulty", "Medium")
		Score.difficult["hard"]:
			emit_signal("update_difficulty", "Difficult")

# Método para manejar la imagen seleccionada.
func handle_value_selected(node):
	if(selected_image and not node == selected_image):
		selected_image.fondo_clic.visible = false  # Ocultar la selección anterior.
	selected_image = node  # Asignar la nueva selección.
	
# Método para manejar el emparejamiento de valores.
func handle_value_match(target_node):
	if !selected_image:
		target_node.fondo_clic.visible = false  # Si no hay imagen seleccionada, no hacer nada.
		return
	if selected_image.value == target_node.target:
		# Si el valor coincide, marcar como bloqueado y reproducir la animación de acierto.
		selected_image.blocked = true
		target_node.blocked = true
		selected_image.animation_match()
		target_node.animation_match()
		target_node.mark_to_match()
		$AnimationPlayer.play("correct")
	else:
		# Si no coincide, disminuir la precisión y reproducir la animación de fallo.
		if(precisionActual>precisionMinima):
			precisionActual -= 10
		selected_image.animation_no_match()
		target_node.animation_no_match()
		selected_image.fondo_clic.visible = false
		$AnimationPlayer.play("incorrect")
	selected_image = null

# Método para iniciar el juego.
func iniciar_juego():
	emit_signal("update_level", str(numeroRondas)+"/5")
	# Create a list of pairs (image, name) for shuffling
	var image_name_pairs = []
	for i in range(3):
		image_name_pairs.append({"image": images[i], "name": names[i]})
	# Shuffle the pairs for randomized image order
	randomize()
	image_name_pairs.shuffle()
	# Shuffle names independently for randomized text order
	var shuffled_names = names.slice(0, 3).duplicate()
	shuffled_names.shuffle()
	# Assign shuffled images and names
	box_imagen_match.put_image(image_name_pairs[0]["image"], image_name_pairs[0]["name"])  # Randomized image order
	box_imagen_match_2.put_image(image_name_pairs[1]["image"], image_name_pairs[1]["name"])  # Randomized image order
	box_imagen_match_3.put_image(image_name_pairs[2]["image"], image_name_pairs[2]["name"])  # Randomized image order
	box_texto_match.put_text(shuffled_names[0])  # Randomized name order
	box_texto_match_2.put_text(shuffled_names[1])  # Randomized name order
	box_texto_match_3.put_text(shuffled_names[2])  # Randomized name order
	ganoRonda=false

# Método para cargar una nueva ronda.
func cargar_ronda():
	reset_compoments()
	emit_signal("update_level", str(numeroRondas) + "/5")
	# Calculate the range of indices for the current round
	var start_index = (numeroRondas - 1) * 3
	var end_index = start_index + 3

	# Get names and images for this round
	var round_names = names.slice(start_index, end_index)
	var round_images = images.slice(start_index, end_index)

	# Create a list of pairs (image, name) for shuffling
	var image_name_pairs = []
	for i in range(3):
		image_name_pairs.append({"image": round_images[i], "name": round_names[i]})
	
	# Shuffle the pairs for randomized image order
	randomize()
	image_name_pairs.shuffle()

	# Shuffle names independently for randomized text order
	var shuffled_names = round_names.duplicate()
	shuffled_names.shuffle()

	# UI elements for images and texts
	var match_boxes = [box_imagen_match, box_imagen_match_2, box_imagen_match_3]
	var text_boxes = [box_texto_match, box_texto_match_2, box_texto_match_3]

	# Assign shuffled images and names
	for i in range(3):
		match_boxes[i].put_image(image_name_pairs[i]["image"], image_name_pairs[i]["name"])  # Randomized image order
		text_boxes[i].put_text(shuffled_names[i])  # Randomized name order
	ganoRonda=false
	
# Método para reiniciar los componentes entre rondas.
func reset_compoments():
	box_imagen_match.animation_reset()
	box_imagen_match_2.animation_reset()
	box_imagen_match_3.animation_reset()
	box_texto_match.animation_reset()
	box_texto_match_2.animation_reset()
	box_texto_match_3.animation_reset()

# Método llamado cuando se gana una ronda.
func ronda_win():
	# Disable hint functionality during animation
	$Box_inside_game2/btns_inside_box_game/btn_instructions.disabled = true
	$Box_inside_game.timer.stop()
	await animation_win()
	await cargar_ronda()
	$Box_inside_game.timer.start()
	# Re-enable hint functionality after new round is loaded
	$Box_inside_game2/btns_inside_box_game/btn_instructions.disabled = false
	
# Método para dar una pista en el juego de manera aleatoria.
var pistas_restantes = 2
func _dar_pista():
	if pistas_restantes <= 0:
		#$Box_inside_game/btns_inside_box_game/btn_instructions.disabled=true
		hints_label.text = "No hints remaining!"
		hints_panel.visible = true
		get_tree().create_timer(3.0).connect("timeout", Callable(self, "_hide_hints_panel"))
		print("No quedan más pistas disponibles.")
		return
	pistas_restantes -= 1
	hints_label.text = str(pistas_restantes) + " Hints Remaining"
	# Show the panel when the button is pressed
	hints_panel.visible = true
	# Optionally, hide the panel after a delay (e.g., 2 seconds)
	get_tree().create_timer(3.0).connect("timeout", Callable(self, "_hide_hints_panel"))

	var images = [box_imagen_match, box_imagen_match_2, box_imagen_match_3]
	var words = [box_texto_match, box_texto_match_2, box_texto_match_3]
	var indices_a_eliminar = []
	for i in range(images.size()):
		if(images[i].blocked):
			indices_a_eliminar.append(i)
			
	indices_a_eliminar.reverse()
	for i in indices_a_eliminar:
		images.pop_at(i)
	
	images.shuffle()
	var image_pista = images.pop_front()
	
	for word in words:
		if image_pista.value == word.target:
			image_pista.animation_pista()
			word.animation_pista()

func _hide_hints_panel():
	hints_panel.visible = false


# Método para manejar la victoria del jugador. Se ejecuta cuando se han pasado todas las rondas del nivel
func victory():	
	instance.position = Vector2(1000,0)
	$Box_inside_game2.timer.stop()
	_actualizar_velocidad()
	_actualizar_puntajes(ejecutablePath+"/Scores/puntajesMatch.dat")
	actualizar_progreso(ejecutablePath+"/Progress/progressMinigames.dat")
	var totalActual = velocidad+precisionActual+valorNivel
	print("Velocidad: "+str(velocidad)+", "+"Precision: "+str(precisionActual)+", "+"Niveles: "+str(valorNivel)+", Total: "+str(totalActual))
	Score.newScore = valorNivel
	Score.LatestGame = Score.Games.Puzzle
	Score.perfectBonus = precisionActual
	Score.fastBonus = velocidad
	animation_win()
	await $AnimationPlayer.animation_finished
	var canvas_layer = CanvasLayer.new()
	canvas_layer.add_child(instanceDifuminado)
	var canvas_layer1 = CanvasLayer.new()
	canvas_layer1.add_child(instance)
	add_child(canvas_layer)
	add_child(canvas_layer1)
	$AudioStreamPlayer2D.play()
	while(instance.position.x > 0):
		await get_tree().create_timer(0.000000001).timeout
		instance.position.x-=50
		
# Método que ejecuta la animación de victoria.
func animation_win():
	$AnimationPlayer.play("Win")
	await $AnimationPlayer.animation_finished

func actualizar_progreso(path):
	if FileAccess.file_exists(path):  # Verifica si el archivo existe  
		var file = FileAccess.open(path, FileAccess.READ)# Abre el archivo en modo lectura
		var progreso = file.get_var()
		file = null
		var esPrimeraVez = false
		match Score.actualDifficult:
			Score.difficult["easy"]:
				if (progreso["match"]["medium"] && progreso["match"]["firstMedium"] == false):
					esPrimeraVez = false
				else:
					esPrimeraVez = true		
					progreso["match"]["medium"] = true
					progreso["match"]["firstMedium"] = true				
			Score.difficult["medium"]:
				if (progreso["match"]["hard"] && progreso["match"]["firstHard"] == false):
					esPrimeraVez = false
				else:
					esPrimeraVez = true		
					progreso["match"]["hard"] = true
					progreso["match"]["firstHard"] = true
		if(esPrimeraVez):	
			if DirAccess.remove_absolute(path) == OK:	 
				print("Archivo PROGRESO existente borrado.")
				var new_file = FileAccess.open(path ,FileAccess.WRITE)
				new_file.store_var(progreso)
				new_file = null
			else:
				print("Error al intentar borrar el archivo PROGRESO.")
	
# Método que se ejecuta cuando el jugador pierde o se detiene el cronometro.
func lose():
	$Box_inside_game2.timer.stop()
	get_tree().paused = true
	instanceAcaboTiempo.nombreEscenaDificultad = "DificultadUnir1.tscn"
	instanceAcaboTiempo.position = Vector2(1000,0)
	var canvas_layer = CanvasLayer.new()
	canvas_layer.add_child(instanceDifuminado)
	var canvas_layer1 = CanvasLayer.new()
	canvas_layer1.add_child(instanceAcaboTiempo)
	add_child(canvas_layer)
	add_child(canvas_layer1)
	while(instanceAcaboTiempo.position.x > 0):
		await get_tree().create_timer(0.000000001).timeout
		instanceAcaboTiempo.position.x-=50

# Método para actualizar la velocidad del jugador basado en el tiempo restante.
func _actualizar_velocidad():
	var tiempoFinal = $Box_inside_game2.time_seconds
	if (tiempoFinal >  tiempoCronometro/1.8):
		velocidad+=80
	elif (tiempoFinal >  tiempoCronometro/2):
		velocidad+=60
	elif (tiempoFinal >  tiempoCronometro/4):
		velocidad+=40
	else:
		velocidad+=0
	var content = {"niveles": valorNivel, "velocidad": velocidad}

# Método para actualizar los puntajes del jugador.
func _actualizar_puntajes(path):
	var content
	if FileAccess.file_exists(path):  # Verifica si el archivo existe  
		var file = FileAccess.open(path, FileAccess.READ)# Abre el archivo en modo lectura
		var puntajes = file.get_var()  # Lee el diccionario de puntajes almacenado
		file.close()  # Cierra el archivo después de leer
		print("Puntajes cargados: ", puntajes)
		var velocidadPasada = puntajes[Score.actualDifficult]["velocidad"]
		var precisionPasada = puntajes[Score.actualDifficult]["precision"]
		var nivelesPasado = puntajes[Score.actualDifficult]["niveles"]
		'''
		content = {
			"easy": {
				"velocidad":velocidadPasada,
				"precision":precisionPasada,
				"niveles":nivelesPasado	
			},"medium": {
				"velocidad":0,
				"precision":0,
				"niveles":0
			},"hard": {
				"velocidad":0,
				"precision":0,
				"niveles":0	
			}
		}
		'''
		if int(velocidadPasada) < velocidad:
			puntajes[Score.actualDifficult]["velocidad"] = velocidad
		if int(precisionPasada) < precisionActual:
			puntajes[Score.actualDifficult]["precision"] = precisionActual
		if int(nivelesPasado) < valorNivel:
			puntajes[Score.actualDifficult]["niveles"] = valorNivel
		if int(velocidadPasada) < velocidad || int(precisionPasada) < precisionActual || int(nivelesPasado) < valorNivel:
			if DirAccess.remove_absolute(path) == OK:
	 
				print("Archivo existente borrado.")
				_guardar_puntajes(puntajes, path)
			else:
				print("Error al intentar borrar el archivo.")
		
		
	else:
		match Score.actualDifficult:
			Score.difficult["easy"]:
				content = {
					"easy": {
						"velocidad":velocidad,
						"precision":precisionActual,
						"niveles":valorNivel	
					},"medium": {
						"velocidad":0,
						"precision":0,
						"niveles":0
					},"hard": {
						"velocidad":0,
						"precision":0,
						"niveles":0	
					}
				}
			Score.difficult["medium"]:
				content = {
					"easy": {
						"velocidad":0,
						"precision":0,
						"niveles":0	
					},"medium": {
						"velocidad":velocidad,
						"precision":precisionActual,
						"niveles":valorNivel	
					},"hard": {
						"velocidad":0,
						"precision":0,
						"niveles":0	
					}
				}
			Score.difficult["hard"]:
				content = {
					"easy": {
						"velocidad":0,
						"precision":0,
						"niveles":0
					},"medium": {
						"velocidad":0,
						"precision":0,
						"niveles":0
					},"hard": {
						"velocidad":velocidad,
						"precision":precisionActual,
						"niveles":valorNivel	
					}
				}
		_guardar_puntajes(content, path)		

# Método para guardar los puntajes actualizados.
func _guardar_puntajes(content, path):
	var file = FileAccess.open(path ,FileAccess.WRITE)
	file.store_var(content)
	file = null

# Método para volver a la pantalla de selección de niveles.
func go_selection():
	get_tree().change_scene_to_file("res://Escenas/menu_juegos.tscn")
