extends Area2D

@export var bruja_scene: PackedScene
var bruja_instance

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and bruja_instance == null:
		call_deferred("_spawn_bruja", body)

func _spawn_bruja(body):
	bruja_instance = bruja_scene.instantiate()
	bruja_instance.position = Vector2(50, -12) 
	get_parent().add_child(bruja_instance)

	if bruja_instance.has_method("play"):
		bruja_instance.play("idle")

	# Acceder al sistema de diálogo (si lo tienes en la escena principal)
	var dialogo = get_tree().get_first_node_in_group("DialogUI")
	dialogo.start([
		"¡Mortal imprudente!",
		"Yo soy la bruja que domina este bosque.",
		"Toma este poder... pero cuidado con lo que deseas."
	])


	body.power_active = true
