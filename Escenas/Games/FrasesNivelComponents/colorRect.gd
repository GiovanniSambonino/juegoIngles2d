extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "color", Color(0.827,0.09,0.188,0.5), 1).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "color", Color(0.827,0.09,0.188,0.0), 1).set_trans(Tween.TRANS_SINE)
	tween.play()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
