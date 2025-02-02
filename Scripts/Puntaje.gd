extends Node2D
var score = 0
var bonus = 0
var fastBonus=0
var perfectBonus=0
# Called when the node enters the scene tree for the first time.
func _ready():
	updateScore()
	score = 0
	fastBonus=0
	perfectBonus=0
	if(Score.perfectBonus<80):
		$Perfecto.text = "Buen trabajo"
	elif(Score.perfectBonus<100):
		$Perfecto.text = "Casi perfecto"
	if(Score.fastBonus<80):
		$"Bonus de velocidad".text="Veloz"
	
	pass

func updateScore():
	bonus+=Score.fastBonus+Score.perfectBonus
	await get_tree().create_timer(1).timeout
	var tempScore = score
	$AudioStreamPlayer2D.play(0.0)
	while(score<(tempScore+Score.newScore)):
		await get_tree().create_timer(0.01).timeout
		score+=5
	$AudioStreamPlayer2D.stop()
	await get_tree().create_timer(0.8).timeout
	$AudioStreamPlayer2D.play(0.0)
	while(fastBonus<Score.fastBonus):
		await get_tree().create_timer(0.01).timeout
		fastBonus+=5
	$AudioStreamPlayer2D.stop()
	await get_tree().create_timer(0.8).timeout
	$AudioStreamPlayer2D.play(0.0)
	while(perfectBonus<Score.perfectBonus):
		await get_tree().create_timer(0.01).timeout
		perfectBonus+=5
	$AudioStreamPlayer2D.stop()
	await get_tree().create_timer(0.5).timeout
	$AudioStreamPlayer2D.play(0.0)
	while(score<(tempScore+Score.newScore+bonus)):
		await get_tree().create_timer(0.01).timeout
		score+=5
	$AudioStreamPlayer2D.stop()
	
	#Score.OrderItScore += score
	#Score.PlayerScore+=score

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func _process(delta):
	$Puntaje.text = str(score)
	$Puntaje2.text = "+"+str(fastBonus)
	$Puntaje3.text = "+"+str(perfectBonus)
	

func _on_button_pressed():
	ButtonClick.button_click()
	get_tree().change_scene_to_file("res://Escenas/menu_juegos.tscn")

