extends Node
var palabrasEsp = [
	["Él juega fútbol muy bien" , "Él patea muy fuerte"], 
	["Yo leo la hoja", "Él lee la hoja"], 
	["Ella barre el piso", "Ella limpia la casa"],
	["Ellos cantan una canción", "Nosotros cantamos juntos"],
	["Él trabaja en su computadora", "Él trabaja en la oficina"],
	["Te gusta jugar golf", "A él le encanta jugar golf"], 
	["Yo juego con mi perro", "Él juega con su perro"], 
	["Mario enseña matemáticas", "Él está enseñando matemáticas"], 
	["El hombre está paseando a su perro", "Él pasea a su perro"], 
	["Él está pescando varios peces", "A él le gusta pescar"],
]  
  
var palabrasEspMedium = [
	["Él juega al fútbol muy bien con pasion", "Él juega al fútbol con pasión y fuerza"],
	["Yo leo el libro todos los dias en casa", "Yo leo la pagina todos los dias en casa"],
	["Ella barre el piso con fuerza", "Ella barre el piso de la sala y la cocina"],
	["Ellos cantan una canción alegre", "Ellos cantan una canción juntos en el coro"],
	["Él trabaja en su computadora todo el dia en casa", "Él trabaja en su computadora en casa y oficina"],
	["Te gusta jugar golf en el parque", "Te gusta jugar golf los fines de semana en familia"],
	["Yo juego con mi perro felizmente", "Yo juego con mi perro en el jardín cada tarde"],
	["Mario enseña matemáticas con entusiasmo", "Mario enseña matemáticas a estudiantes cada día"],
	["El hombre pasea a su perro felizmente", "El hombre pasea a su perro en el parque todos los días"],
	["Él está pescando peces grandes en el río", "Él está pescando peces grandes cada fin de semana"]
]
  
var palabrasEspHard = [
	["Él juega al fútbol con sus amigos en el parque grande", "Él corre rápido y anota un gol con gran entusiasmo"],
	["Yo leo un libro interesante en la biblioteca con calma", "La historia es emocionante y me enseña muchas cosas"],
	["Ella barre el piso con fuerza en toda la casa cada día", "Primero limpia la sala y después el comedor con cuidado"],
	["Ellos cantan una canción alegre en la escuela por la tarde", "La música es divertida y todos cantan con mucha energía"],
	["Él trabaja en su computadora para terminar un gran proyecto", "Escribe códigos importantes con paciencia y concentración"],
	["Te gusta jugar golf con tus amigos en el parque los sábados", "Practicas los tiros y disfrutas competir con los demás"],
	["Yo juego con mi perro felizmente en el jardín después de clase", "Le lanzo la pelota y él la trae corriendo muy contento"],
	["Mario enseña matemáticas a los estudiantes en la escuela grande", "Explica problemas difíciles y ayuda a todos con paciencia"],
	["El hombre pasea a su perro en el parque todas las mañanas", "Camina lentamente mientras el perro corre feliz a su lado"],
	["Él está pescando peces grandes en el río tranquilo del bosque", "Usa una caña de pescar y espera con calma todo el día"]
]
 


var cadenas = [
	[["He plays", "football", "very well"], ["He hits", "the ball", "very hard"]],
	[["I read", "the", "paper"], ["He reads", "the", "paper"]],
	[["She", "sweeps", "the floor"], ["She", "cleans", "the house"]],
	[["They", "sing", "a song"], ["We", "sing", "together"]],
	[["He works", "on his", "computer"], ["He works", "at the", "office"]],
	[["You", "like to", "play golf"], ["He loves", "to play", "golf"]],
	[["I play", "with", "my dog"], ["He plays", "with", "his dog"]],
	[["Mario", "teaches", "math"], ["He is", "teaching", "math"]],
	[["The man", "is walking", "his dog"], ["He", "walks his", "dog"]],
	[["He is", "catching", "some fish"], ["He", "likes to", "fish"]] , 
]  
	
var cadenasMedium = [
	[["He plays", "football", "very well", "with passion"], 
	  ["He plays", "football", "with passion", "and energy"]], 
	[["I read", "the book", "every day", "at home"], 
	 ["I read", "the page", "every day", "at house"]],
	[["She sweeps", "the floor", "with force", "and broom"], 
	 ["She sweeps", "the floor", "living room", "and kitchen"]],
	[["They sing", "a song", "with joy", "in chorus"], 
	 ["They sing", "a song", "together happy", "in choir"]],
	[["He works", "on computer", "all day", "at home"], 
	 ["He works", "on computer", "in house", "and office"]],
	[["You like", "playing golf", "in park", "on weekend"], 
	 ["You like", "playing golf", "in family", "on Sundays"]],
	[["I play", "with dog", "in yard", "every day"], 
	 ["I play", "with dog", "in garden", "each afternoon"]],
	[["Mario teaches", "mathematics well", "with love", "every day"], 
	 ["Mario teaches", "math daily", "to students", "with care"]],
	[["Man walks", "his dog", "in park", "every day"], 
	 ["Man walks", "his dog", "in park", "happy walks"]],
	[["He fishes", "big fish", "in river", "on weekends"], 
	 ["He fishes", "big fish", "every week", "with patience"]]
]
var cadenasHard = [
	[["He plays", "football with", "his friends", "in park", "runs fast", "scores goal"], 
	 ["He runs", "very fast", "kicks ball", "and scores", "with joy", "big goal"]],
	[["I read", "a book", "in library", "with calm", "it teaches", "many things"], 
	 ["The story", "is fun", "and exciting", "I learn", "new things", "every day"]],
	[["She sweeps", "the floor", "in house", "with broom", "very clean", "everywhere neat"], 
	 ["She starts", "in living", "room and", "cleans dining", "room after", "very tidy"]],
	[["They sing", "a song", "at school", "in afternoon", "music fun", "everyone sings"], 
	 ["The music", "is great", "and happy", "they sing", "with joy", "all together"]],
	[["He works", "on computer", "all day", "writing code", "big project", "with focus"], 
	 ["He writes", "new code", "and solves", "big problems", "works hard", "very skilled"]],
	[["You play", "golf with", "your friends", "in park", "on weekend", "have fun"], 
	 ["You practice", "your swings", "and compete", "with others", "on Saturday", "great time"]],
	[["I play", "with dog", "in garden", "after school", "throw ball", "he fetches"], 
	 ["The dog", "is happy", "he runs", "very fast", "brings ball", "back to me"]],
	[["Mario teaches", "math in", "big school", "to students", "every day", "helps them"], 
	 ["He explains", "hard problems", "very clearly", "students learn", "and enjoy", "his class"]],
	[["Man walks", "his dog", "in park", "every morning", "dog runs", "very happy"], 
	 ["The dog", "is playful", "he barks", "and wags", "his tail", "great walk"]],
	[["He fishes", "big fish", "in river", "in forest", "waits calm", "catches fish"], 
	 ["The river", "is quiet", "he waits", "all day", "catches fish", "and smiles"]]
]
 
 
var cadenasOrdenadas = cadenas.duplicate(true)
var cadenasOrdenadasMedium = cadenasMedium.duplicate(true)  
var cadenasOrdenadasHard = cadenasHard.duplicate(true)  
var images = ["futbol1", "leehoja", "barre", "cantan", "compu", "golf", "juegaperro", "mates", "pasea", "pesca"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
