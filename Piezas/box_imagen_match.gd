extends Node2D

# Valor asociado con la imagen para el emparejamiento.
var value = "a"  

# Referencias a nodos en la escena.
@onready var fondo_clic = $Button/Fondo_clic
var blocked = false  # Indica si la imagen está bloqueada (ya emparejada).
@onready var imagen = $Button/imagen
@onready var animation_image = $AnimationImage

func _ready():
	# Inicializar la visibilidad del fondo de clic.
	fondo_clic.visible = false

# Función para colocar una imagen en el nodo y asignarle un valor.
func put_image(url_path, entry_value):
	imagen.texture = load(url_path)  # Cargar la textura de la imagen desde la ruta proporcionada.
	value = entry_value  # Asignar el valor asociado con la imagen.
	
# Método que se ejecuta cuando se presiona el botón asociado a la imagen.
func _on_button_pressed():
	if blocked:
		# Si la imagen está bloqueada, no hacer nada.
		return
	# Mostrar el fondo de clic al seleccionar la imagen.
	fondo_clic.visible = true
	# Notificar al nodo padre que esta imagen ha sido seleccionada.
	get_parent().handle_value_selected(self)
	
# Animación que se ejecuta cuando se logra un emparejamiento correcto.
func animation_match():
	animation_image.play("Match")  # Reproducir la animación de emparejamiento correcto.

# Animación que se ejecuta cuando el emparejamiento falla.
func animation_no_match():
	animation_image.play("No_match")  # Reproducir la animación de error.

# Animación que se ejecuta cuando se proporciona una pista.
func animation_pista():
	animation_image.play("Pista")  # Reproducir la animación de pista.

# Animación para reiniciar el estado del componente.
func animation_reset():
	blocked = false  # Desbloquear la imagen.
	animation_image.play("RESET")  # Reproducir la animación de reinicio.
