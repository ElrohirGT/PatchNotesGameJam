extends CanvasLayer

@export var texto_por_segundo: float = 30.0

var lineas: Array = []
var indice_actual: int = 0
var mostrando_texto: bool = false

signal dialogo_terminado

@onready var label_texto = $Panel/Label
@onready var write_timer: Timer = $WriteTimer

var _text_to_write: String = ""
var _write_index: int = 0

func _ready() -> void:
	# conectar el timeout
	if not write_timer.is_connected("timeout", Callable(self, "_on_WriteTimer_timeout")):
		write_timer.timeout.connect(_on_WriteTimer_timeout)
	# asegurarnos de que el timer esté parado
	write_timer.stop()

func start(dialogos: Array) -> void:
	lineas = dialogos
	indice_actual = 0
	show()
	mostrar_linea()

func mostrar_linea() -> void:
	if indice_actual >= lineas.size():
		hide()
		emit_signal("dialogo_terminado")
		return

	_text_to_write = lineas[indice_actual]
	label_texto.text = ""
	_write_index = 0
	mostrando_texto = true

	# ajustar velocidad del timer
	write_timer.wait_time = 1.0 / max(1.0, texto_por_segundo)
	write_timer.start()

func _on_WriteTimer_timeout() -> void:
	if _write_index < _text_to_write.length():
		label_texto.text += _text_to_write[_write_index]
		_write_index += 1
	else:
		write_timer.stop()
		mostrando_texto = false

func _input(event) -> void:
	if event.is_action_pressed("ui_accept"):
		if mostrando_texto:
			# mostrar la línea completa y detener el timer
			write_timer.stop()
			label_texto.text = lineas[indice_actual]
			mostrando_texto = false
		else:
			indice_actual += 1
			mostrar_linea()
