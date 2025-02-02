extends Node2D

#Signals
#Señales para actualizar titulos y demás características del juego
signal set_timer()
signal update_title(new_title)
signal update_difficulty(new_difficulty)
signal update_level(new_level)
signal uptate_imagen_game(new_image)
#signal set_visible_word(new_word)
signal set_visible_sentence(new_sentence)
signal update_phrase()

#Precarga de modales de victoria y tiempo culminado
var pantallaVictoria = preload("res://Escenas/PantallaVictoria.tscn")
var pantallaAcaboTiempo = preload("res://Escenas/NivelFinalizado.tscn")
var difuminado = preload("res://Piezas/ColorRectDifuminado.tscn")
var instance

#Ruta donde se encuentra el ejecutable
var ejecutablePath = Global.rutaArchivos
#var palabra ="bird"

#Variables para manejar las instancias de los modales
var instantiated = false
var instanceAcaboTiempo
var instantiatedAcaboTiempo = false
var instanceDifuminado
var instantiatedDifuminado = false

#Variables para llevar la lógica de rondas y ganar en el juego. Banco donde se encuntran las frases para el puzzle
var gano = false
var ganoRonda = false
var palabrasEsp = BancoFrases.palabrasEsp
var cadenas = BancoFrases.cadenas
var cadenasOrdenadas = BancoFrases.cadenasOrdenadas
var images = BancoFrases.images
var indicesImages = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
var indiceNivel = -1
var indiceImagen = 0
var indiceCadena = 0
var estadoInicialPiezas = []
var rondas = 4
var numeroRondas = 0
var precisionMinima = 20
var precisionActual = 100
var velocidad = 20
var valorNivel = 100 
var tiempoCronometro = 120 

# Muestra instrucciones, actualiza titulos e instancia variables. Empieza ronda
func _ready():
	Score.perfectBonus = 0
	instance = pantallaVictoria.instantiate()
	instantiated = true
	instanceAcaboTiempo = pantallaAcaboTiempo.instantiate()
	instantiatedAcaboTiempo = true
	instanceDifuminado = difuminado.instantiate()
	instantiatedDifuminado = true
	emit_signal("set_timer")
	emit_signal("update_title", "Puzzle")
	setDifficultTitle()
	for i in range(3):
		var pieza = $Cadenas.get_node("Pieza"+str(i))
		estadoInicialPiezas.append({"position": pieza.position})
	tiempoCronometro = 121 #$Box_inside_game.time_seconds 
	_empezar_ronda()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func setDifficultTitle():
	match Score.actualDifficult:
		Score.difficult["easy"]:
			emit_signal("update_difficulty", "Easy")
		Score.difficult["medium"]:
			emit_signal("update_difficulty", "Medium")
		Score.difficult["hard"]:
			emit_signal("update_difficulty", "Difficult")
		
#Verifica si el jugador ha ganado la ronda o el juego
func _process(_delta):
	if(instantiated):
		if ($Cadenas/Pieza0.correct and $Cadenas/Pieza1.correct and
		  $Cadenas/Pieza2.correct and numeroRondas == rondas and !gano):
			gano = true
			victory()
		elif ($Cadenas/Pieza0.correct and $Cadenas/Pieza1.correct and
		  $Cadenas/Pieza2.correct and numeroRondas < rondas and !ganoRonda and !gano):
			ganoRonda = true
			numeroRondas+=1
			if(numeroRondas < rondas):		
				rondaWin()
			
	pass

#Se invoca al empezar una nueva ronda
func _empezar_ronda():		
	indiceNivel += 1
	var indiceAl = randi_range(0, indicesImages.size()-1)
	indiceImagen = indicesImages[indiceAl]
	indicesImages.remove_at(indiceAl)
	print(str(indiceImagen))
	indiceCadena = randi_range(0, cadenas[indiceImagen].size()-1)
	print(str(indiceCadena))
	emit_signal("set_visible_sentence", palabrasEsp[indiceImagen][indiceCadena])
	emit_signal("update_level", str(indiceNivel+1)+"/"+str(rondas))
	emit_signal("uptate_imagen_game", "puzzle/"+images[indiceImagen])
	update_boxes(indiceCadena)
	ganoRonda=false
	

#Reinicia los objetos al empezar una ronda
func _reiniciar_componentes():
	var x=0
	for dicc in estadoInicialPiezas:
		var pieza = $Cadenas.get_node("Pieza"+str(x))
		var piezaBox = $Ordenada.get_node("piezaBox"+str(x))
		pieza.position = dicc["position"]
		pieza._reiniciar_variables()
		piezaBox._reiniciar_variables()
		x+=1
	_animacion_retorno()
	_empezar_ronda()

#Quita los colores de correcto de las piezas con una animación
func _animacion_retorno():
	for i in range(3):
		var pieza = $Cadenas.get_node("Pieza"+str(i))
		pieza._animacion_retorno()
	
#Da pista tomando en cuenta las píezas que no han sido puestas
func _dar_pista():
	var numeros = [0, 1, 2] 
	while numeros.size() > 0:
		# Selecciona un índice aleatorio dentro del rango de la lista
		var indice_aleatorio = randi() % numeros.size()     
		print(indice_aleatorio)
		# Obtiene el número en el índice aleatorio
		var numero_seleccionado = numeros[indice_aleatorio] 
		print(numero_seleccionado)       
		var pieza = "Pieza"+str(numero_seleccionado)
		var nodePieza = $Cadenas.get_node(pieza)
		if(!nodePieza.correct):
			var posicionCadena = cadenasOrdenadas[indiceImagen][indiceCadena].find(nodePieza.letter)
			var piezaBox = "piezaBox"+str(posicionCadena)
			var nodePiezaBox = $Ordenada.get_node(piezaBox)
			nodePieza._animacion_pista()
			nodePiezaBox._animacion_pista()	
			return	 	
		numeros.remove_at(indice_aleatorio) 
	
#Actualiza la textura y texto en las piezas
func update_boxes(index: int):
	cadenas[indiceImagen][index].shuffle()
	var x=0	
	for cadena in cadenas[indiceImagen][index]:
		var nombrePieza = "Pieza"+str(x)
		var nombrePiezaBox = "piezaBox"+str(x)
		var pieza_objetivo = get_node("Cadenas/"+nombrePieza)
		pieza_objetivo.letter = cadena
		var pieza_box_objetivo = get_node("Ordenada/"+nombrePiezaBox)
		pieza_box_objetivo.letter = cadenasOrdenadas[indiceImagen][index][x]
		x+=1
		var posicion = cadenasOrdenadas[indiceImagen][index].find(cadena)
		var sprite_pz_objetivo = get_node("Cadenas/"+nombrePieza+"/InteractivoLetra(vacio)")
		cargar_nueva_textura(sprite_pz_objetivo, posicion)
		
		
	emit_signal("update_phrase")
		
#Actualiza textura en una pieza
func cargar_nueva_textura(sprite, index):
	var nueva_textura
	if index==0:
		nueva_textura = load("res://Sprites/mini_games/pieza3.png")
	elif index==1:
		nueva_textura = load("res://Sprites/mini_games/pieza1.png")
	else:
		nueva_textura = load("res://Sprites/mini_games/pieza2.png")
	sprite.texture = nueva_textura

#Actualiza el bonus de velocidad según el cronómetro
func _actualizar_velocidad():
	var tiempoFinal = $Box_inside_game.time_seconds
	if (tiempoFinal >  tiempoCronometro/1.8):
		velocidad+=80
	elif (tiempoFinal >  tiempoCronometro/2):
		velocidad+=60
	elif (tiempoFinal >  tiempoCronometro/4):
		velocidad+=40
	else:
		velocidad+=0
	var content = {"niveles": valorNivel, "velocidad": velocidad}

#Actaulizar los puntajes en el archivo de puntajes
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
		
			 
	
#Guarda los puntajes en el archivo
func _guardar_puntajes(content, path):
	var file = FileAccess.open(path ,FileAccess.WRITE)
	file.store_var(content)
	file = null

func actualizar_progreso(path):
	if FileAccess.file_exists(path):  # Verifica si el archivo existe  
		var file = FileAccess.open(path, FileAccess.READ)# Abre el archivo en modo lectura
		var progreso = file.get_var()
		file = null
		var esPrimeraVez = false
		match Score.actualDifficult:
			Score.difficult["easy"]:
				if (progreso["puzzle"]["medium"] && progreso["puzzle"]["firstMedium"] == false):
					esPrimeraVez = false
				else:
					esPrimeraVez = true		
					progreso["puzzle"]["medium"] = true
					progreso["puzzle"]["firstMedium"] = true				
			Score.difficult["medium"]:
				if (progreso["puzzle"]["hard"] && progreso["puzzle"]["firstHard"] == false):
					esPrimeraVez = false
				else:
					esPrimeraVez = true		
					progreso["puzzle"]["hard"] = true
					progreso["puzzle"]["firstHard"] = true
		if(esPrimeraVez):	
			if DirAccess.remove_absolute(path) == OK:	 
				print("Archivo PROGRESO existente borrado.")
				var new_file = FileAccess.open(path ,FileAccess.WRITE)
				new_file.store_var(progreso)
				new_file = null
			else:
				print("Error al intentar borrar el archivo PROGRESO.")
		
#Se invoca cuando el jugador gana
func victory():
	instance.position = Vector2(1000,0)
	$Box_inside_game.timer.stop()
	_actualizar_velocidad()
	_actualizar_puntajes(ejecutablePath+"/Scores/puntajesPuzzle.dat")
	actualizar_progreso(ejecutablePath+"/Progress/progressMinigames.dat")
	var totalActual = velocidad+precisionActual+valorNivel
	print("Velocidad: "+str(velocidad)+", "+"Precision: "+str(precisionActual)+", "+"Niveles: "+str(valorNivel)+", Total: "+str(totalActual))
	Score.newScore = valorNivel
	Score.fastBonus = velocidad
	Score.perfectBonus = precisionActual
	Score.LatestGame = Score.Games.Puzzle

	$AnimationPlayer.play("Gana")
	var pieza0 = get_node("Cadenas/Pieza0")
	var pieza1 = get_node("Cadenas/Pieza1")
	var pieza2 = get_node("Cadenas/Pieza2")
	await pieza0._animacion_finalizado()
	await pieza1._animacion_finalizado()
	await pieza2._animacion_finalizado()
	await $AnimationPlayer.animation_finished
	$AudioStreamPlayer2D.play()
	var canvas_layer = CanvasLayer.new()
	canvas_layer.add_child(instanceDifuminado)
	var canvas_layer1 = CanvasLayer.new()
	canvas_layer1.add_child(instance)
	add_child(canvas_layer)
	add_child(canvas_layer1)
	while(instance.position.x > 0):
		await get_tree().create_timer(0.000000001).timeout
		instance.position.x-=50

#Se invoca cuando se acaba el tiempo
func lose():
	$Box_inside_game.timer.stop()
	get_tree().paused = true
	instanceAcaboTiempo.nombreEscenaDificultad = "DificultadOracion1.tscn"
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

#Se invoca cada vez que se gana una ronda
func rondaWin():
	$AnimationPlayer.play("Gana")
	var pieza0 = get_node("Cadenas/Pieza0")
	var pieza1 = get_node("Cadenas/Pieza1")
	var pieza2 = get_node("Cadenas/Pieza2")
	await pieza0._animacion_finalizado()
	await pieza1._animacion_finalizado()
	await pieza2._animacion_finalizado()
	await $AnimationPlayer.animation_finished
	_reiniciar_componentes()
	
#Botón para regresar al menú
func _on_btn_go_back_pressed():
	ButtonClick.button_click()
	get_tree().change_scene_to_file("res://Escenas/menu_juegos.tscn")
