extends Node2D
var nombreEscenaDificultad = "DificultadOracion1.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_casa_button_pressed():
	get_tree().paused = false
	ButtonClick.button_click()
	get_tree().change_scene_to_file("res://Escenas/menu_juegos.tscn")


func _on_reiniciar_button_pressed():
	get_tree().paused = false
	ButtonClick.button_click()
	get_tree().reload_current_scene()
	pass # Replace with function body.


func _on_niveles_button_pressed():
	get_tree().paused = false
	ButtonClick.button_click()
	get_tree().change_scene_to_file("res://Escenas/"+nombreEscenaDificultad)
	
