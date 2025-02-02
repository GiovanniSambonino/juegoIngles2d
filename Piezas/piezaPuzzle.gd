extends Node2D

@export var letter = "A" 
var dragging = false
var originalpos = Vector2()  # Inicializado en _ready()
var snap_to = Vector2()  # Inicializado en _ready()
var target_letter = "A"
var correct = false

func _ready():
	# Establece la posición inicial y el texto del Label
	originalpos = global_position
	snap_to = Vector2()  # Por defecto, no hay una posición de ajuste
	_actualizar_label()

	# Verifica la existencia del padre y abuelo antes de conectar la señal
	var parent = get_parent()
	if parent and parent.get_parent():
		var abuelo = parent.get_parent()
		if abuelo.has_signal("update_phrase"):
			abuelo.connect("update_phrase", Callable(self, "_on_update_phrase"))
		else:
			print("Advertencia: El abuelo no tiene la señal 'update_phrase'.")
	else:
		print("Advertencia: Nodo padre o abuelo no encontrado.")

func _process(_delta):
	# Solo actualiza la posición si se está arrastrando
	if dragging:
		position = get_global_mouse_position()
		correct = false
		$AnimationPlayer.play("RESET")

func _get_drag_data(_at_position):
	print("Iniciando arrastre.")

func _on_button_button_down():
	dragging = true
	self.move_to_front()

func _on_button_button_up():
	dragging = false
	if position.distance_to(snap_to) < 70:  # Verifica si está cerca del objetivo
		position = snap_to
		if letter == target_letter:
			_marcar_correcto()
		else:
			_marcar_incorrecto()
	else:
		_reset_position()

func _on_update_phrase():
	originalpos = global_position
	_actualizar_label()

# Función para marcar como correcto
func _marcar_correcto():
	$AnimationPlayer.play("Correcto")
	await $AnimationPlayer.animation_finished
	correct = true

# Función para manejar cuando es incorrecto
func _marcar_incorrecto(): 
	var principal = get_parent().get_parent()
	if principal and principal.has_method("precisionActual"):
		if principal.precisionActual > principal.precisionMinima:
			principal.precisionActual -= 10
	$AnimationPlayer.play("Incorrecto")
	await $AnimationPlayer.animation_finished
	_reset_position()

# Función para reiniciar la posición
func _reset_position():
	position = originalpos
	correct = false
	$AnimationPlayer.play("Retorno")

# Función para actualizar el texto del Label
func _actualizar_label():
	var label = $"InteractivoLetra(vacio)/Label"
	if label:
		label.text = letter
	else:
		print("Advertencia: Nodo Label no encontrado.")

# Funciones auxiliares para animaciones
func _animacion_pista():
	$AnimationPlayer.play("Pista")

func _animacion_finalizado():
	$AnimationPlayer.play("Final")
	await $AnimationPlayer.animation_finished

func _animacion_retorno():
	$AnimationPlayer.play("Retorno")

func _reiniciar_variables():
	originalpos = global_position
	snap_to = Vector2()
	correct = false
	_actualizar_label()
