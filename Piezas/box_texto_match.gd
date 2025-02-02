extends Node2D

# Variable que almacena el texto objetivo que debe coincidir con la imagen.
var target = "a"

# Referencia al nodo Fondo_clic, que controla la visibilidad del fondo cuando se selecciona el texto.
@onready var fondo_clic = $Button/Fondo_clic

# Variable para controlar si el texto está bloqueado (si ya ha sido emparejado).
var blocked = false

# Referencia al nodo Label, que muestra el texto en la interfaz.
@onready var label = $Button/Label

# Referencia al nodo de animación para las acciones de emparejamiento.
@onready var animation = $Animation

# Variable booleana para controlar si el texto ha sido emparejado correctamente.
var matched: bool = false

# Método llamado cuando el nodo entra en la escena por primera vez.
func _ready():
	# Ocultar el fondo de clic al inicio y establecer el texto en la etiqueta.
	fondo_clic.visible = false
	label.text = target.capitalize()

# Método que se ejecuta cuando el botón es presionado.
func _on_button_pressed():
	# Si el texto está bloqueado, no hacer nada.
	if blocked:
		return
	# Hacer visible el fondo de clic cuando se selecciona el texto.
	fondo_clic.visible = true
	# Llamar al método en el nodo padre para manejar la validación del emparejamiento.
	get_parent().handle_value_match(self)

# Método para actualizar el texto en el nodo de la etiqueta.
func put_text(new_text):
	# Asignar el nuevo texto objetivo y actualizar la etiqueta.
	target = new_text
	label.text = target.capitalize()

# Método que ejecuta la animación cuando hay un emparejamiento exitoso.
func animation_match():
	animation.play("match")

# Método que ejecuta la animación cuando no hay un emparejamiento exitoso.
func animation_no_match():
	animation.play("no_match")

# Método que marca el texto como emparejado correctamente.
func mark_to_match():
	matched = true

# Método que retorna si el texto ha sido emparejado correctamente.
func is_matched() -> bool:
	return matched

# Método que ejecuta la animación cuando se proporciona una pista.
func animation_pista():
	animation.play("Pista")

# Método que reinicia el estado de la animación y desbloquea el texto.
func animation_reset():
	blocked = false
	matched = false
	animation.play("RESET")
