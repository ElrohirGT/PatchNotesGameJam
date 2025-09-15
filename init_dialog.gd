extends CanvasLayer

@export var texto_por_segundo: float = 30.0

var lineas: Array = []
var indice_actual: int = 0
var mostrando_texto: bool = false

@onready var label_texto = $Panel/Label

func start(dialogos: Array):
	lineas = dialogos
	indice_actual = 0
	show()
	mostrar_linea()

func mostrar_linea():
	if indice_actual >= lineas.size():
		hide()
		emit_signal("dialogo_terminado")
		return
	
	var texto = lineas[indice_actual]
	label_texto.text = ""
	mostrando_texto = true
	_escribir_texto(texto)

func _escribir_texto(texto: String) -> void:
	var i = 0
	var timer = Timer.new()
	timer.wait_time = 1.0 / texto_por_segundo
	timer.one_shot = false
	add_child(timer)
	timer.start()

	timer.timeout.connect(func ():
		if i < texto.length():
			label_texto.text += texto[i]
			i += 1
		else:
			timer.stop()
			timer.queue_free()
			mostrando_texto = false
	)
	

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if mostrando_texto:
			# Si todavía se está escribiendo, muestra todo de golpe
			label_texto.text = lineas[indice_actual]
			mostrando_texto = false
		else:
			# Si ya terminó, pasa a la siguiente línea
			indice_actual += 1
			mostrar_linea()
