extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.GREEN, 1.5).set_trans(Tween.TRANS_SINE)
	tween.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
