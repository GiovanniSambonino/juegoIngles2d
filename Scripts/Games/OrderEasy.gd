extends Node2D

#Signals
signal set_timer()
signal update_title(new_title)
signal update_difficulty(new_difficulty)
signal update_level(new_level)
signal uptate_imagen_game(new_image)
signal set_visible_word(new_word)
var ejecutablePath = Global.rutaArchivos
var pantallaVictoria = preload("res://Escenas/PantallaVictoria.tscn")
var pantallaAcaboTiempo = preload("res://Escenas/NivelFinalizado.tscn")
var difuminado = preload("res://Piezas/ColorRectDifuminado.tscn")
var instance
var instanceAcaboTiempo
var instantiatedAcaboTiempo = false
var instanceDifuminado
var instantiatedDifuminado = false
var palabras = {"Ave": "BIRD", "Pelota": "BALL", "Gavilán": "HAWK", "Cantar": 
	"SING", "Pescar":"FISH", "Caminar":"WALK","Matemáticas":"MATH", "Leer":"READ",
	"Jugar":"PLAY"}
@export var palabra ="BIRD"
@export var palabraES = "Ave"
var instantiated = false
var gano = false
var letters
var rondas = 4
var rondaActual = 1
var tiempoCronometro = 120 
var velocidad = 20
var perfect = 100
var valorNivel = 100
var palabraAnterior

func _ready():
	Score.perfectBonus=100
	emit_signal("set_timer")
	emit_signal("update_title", "Order it")
	setDifficultTitle()
	emit_signal("update_level", "1/4")
	emit_signal("uptate_imagen_game", "Ave")
	instance = pantallaVictoria.instantiate()
	instantiated = true
	instanceAcaboTiempo = pantallaAcaboTiempo.instantiate()
	instantiatedAcaboTiempo = true
	instanceDifuminado = difuminado.instantiate()
	instantiatedDifuminado = true
	setLetters()
	tiempoCronometro = $Box_inside_game.time_seconds
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(instantiated):
		if ($Letras/Letter.correct and $Letras/Letter2.correct and
		 $Letras/Letter3.correct and $Letras/Letter4.correct and
		 rondaActual==rondas and !gano):
			gano = true
			victory()
		if ($Letras/Letter.correct and $Letras/Letter2.correct and
		 $Letras/Letter3.correct and $Letras/Letter4.correct):
			if(rondaActual<rondas):
				await nuevaRonda()
			else: gano=true
	pass
	
func setDifficultTitle():
	match Score.actualDifficult:
		Score.difficult["easy"]:
			emit_signal("update_difficulty", "Easy")
		Score.difficult["medium"]:
			emit_signal("update_difficulty", "Medium")
		Score.difficult["hard"]:
			emit_signal("update_difficulty", "Difficult")
			
func setLetters():
	palabraES = palabras.keys().pick_random()
	emit_signal("set_visible_word", palabraES)
	palabra = palabras[palabraES]
	letters = palabra.split()
	var tempLetters: Array[String]= []
	while(true):
		tempLetters= []
		for i in letters.size():
			tempLetters.append(letters[i])
		tempLetters.shuffle()
		if (tempLetters[0]!=letters[0]):
			break
	if(palabraAnterior != null):
		$Imagenes.get_node(palabraAnterior).visible = false
	$Imagenes.get_node(palabraES).visible=true
	
	$Letras/Letter.setLetter(tempLetters[0])
	$Letras/Letter2.setLetter(tempLetters[1])
	$Letras/Letter3.setLetter(tempLetters[2])
	$Letras/Letter4.setLetter(tempLetters[3])
	$Ordenada/Letterbox5.setLetter(letters[0])
	$Ordenada/Letterbox6.setLetter(letters[1])
	$Ordenada/Letterbox7.setLetter(letters[2])
	$Ordenada/Letterbox8.setLetter(letters[3])

func victory():
	$Box_inside_game.timer.stop()
	actualizar_velocidad()
	Score.newScore = valorNivel
	Score.fastBonus = velocidad
	Score.LatestGame = Score.Games.OrderIt
	_actualizar_puntajes(ejecutablePath+"/Scores/puntajesOrder.dat")
	actualizar_progreso(ejecutablePath+"/Progress/progressMinigames.dat")
	instance.position = Vector2(1000,0)
	$AnimationPlayer.play("Gana")
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

func _actualizar_puntajes(path):
	var content
	var precisionActual = Score.perfectBonus
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
				if (progreso["order"]["medium"] && progreso["order"]["firstMedium"] == false):
					esPrimeraVez = false
				else:
					esPrimeraVez = true		
					progreso["order"]["medium"] = true
					progreso["order"]["firstMedium"] = true				
			Score.difficult["medium"]:
				if (progreso["order"]["hard"] && progreso["order"]["firstHard"] == false):
					esPrimeraVez = false
				else:
					esPrimeraVez = true		
					progreso["order"]["hard"] = true
					progreso["order"]["firstHard"] = true
		if(esPrimeraVez):	
			if DirAccess.remove_absolute(path) == OK:	 
				print("Archivo PROGRESO existente borrado.")
				var new_file = FileAccess.open(path ,FileAccess.WRITE)
				new_file.store_var(progreso)
				new_file = null
			else:
				print("Error al intentar borrar el archivo PROGRESO.")

func lose():
	$Box_inside_game.timer.stop()
	get_tree().paused = true
	instanceAcaboTiempo.nombreEscenaDificultad = "DificultadPalabra1.tscn"
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

func _dar_pista():
	for i in $Letras.get_children():
		if(!i.correct):
			for j in $Ordenada.get_children():
				if(j.letter == i.letter and !j.occupied):
					i.hint()
					j.hint()
					return
					
func nuevaRonda():
	palabraAnterior=palabraES
	
	palabras.erase(palabraES)
	$Box_inside_game.timer.stop()
	$Letras/Letter.resetVars()
	$Letras/Letter2.resetVars()
	$Letras/Letter3.resetVars()
	$Letras/Letter4.resetVars()
	await $Letras/Letter.animacionFinalizado()
	await $Letras/Letter2.animacionFinalizado()
	await $Letras/Letter3.animacionFinalizado()
	await $Letras/Letter4.animacionFinalizado()
	$Letras/Letter.resetPos()
	$Letras/Letter2.resetPos()
	$Letras/Letter3.resetPos()
	$Letras/Letter4.resetPos()
	rondaActual+=1
	emit_signal("update_level", str(rondaActual)+"/4")
	await setLetters()
	$Box_inside_game.timer.start()
	

func actualizar_velocidad():
	var tiempoFinal = $Box_inside_game.time_seconds
	if (tiempoFinal >  tiempoCronometro/1.8):
		velocidad+=80
	elif (tiempoFinal >  tiempoCronometro/2):
		velocidad+=60
	elif (tiempoFinal >  tiempoCronometro/4):
		velocidad+=40
	else:
		velocidad+=0
