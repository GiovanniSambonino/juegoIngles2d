extends Control

const URL_RES = 'res://Escenas/'
const EXT_RES = '.tscn'

var previous_scene = ''

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().connect("update_scene", Callable(self, "_on_set_previous_scene"))

func _on_set_previous_scene(scene):
	previous_scene = scene

func _on_update_scene():
	ButtonClick.button_click()
	var url = URL_RES + previous_scene + EXT_RES
	get_tree().change_scene_to_file(url)
