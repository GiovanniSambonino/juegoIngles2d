extends Node

var exercises = []
var cadenas = []
var cadenasMedium = []
var cadenasHard = []
var images = []
var palabrasEsp = []        
var palabrasEspMedium = []  
var palabrasEspHard = []  
var cadenasOrdenadas= []
var cadenasOrdenadasMedium  = []
var cadenasOrdenadasHard = [] 
func _ready():
	# Verificamos si existe el archivo JSON en la ruta indicada.
	if FileAccess.file_exists("res://Scripts/Global/BancoFrases.JSON"):
		var json_as_text = FileAccess.get_file_as_string("res://Scripts/Global/BancoFrases.JSON")
		var result = JSON.parse_string(json_as_text)
		if json_as_text: 
			var json_as_dict = result   
			exercises = json_as_dict["exercises"]
			for exercise in exercises:
				cadenas.append(exercise["eng"]["easy"])
				cadenasMedium.append(exercise["eng"]["medium"])
				cadenasHard.append(exercise["eng"]["hard"])
				palabrasEsp.append( exercise["esp"]["easy"] ) 
				palabrasEspMedium.append( exercise["esp"]["medium"] )
				palabrasEspHard.append( exercise["esp"]["hard"] ) 
				images.append(exercise["image"]) 
		else:
			push_error("Error al parsear el JSON: " + str(result.get("error", "clave 'error' no encontrada")))
	else:
		push_error("No se encontró el archivo: res://Scripts/Global/BancoFrases.JSON")
		   
	cadenasOrdenadas = cadenas.duplicate(true) 
	cadenasOrdenadasMedium = cadenasMedium.duplicate(true)  
	cadenasOrdenadasHard = cadenasHard.duplicate(true)  
