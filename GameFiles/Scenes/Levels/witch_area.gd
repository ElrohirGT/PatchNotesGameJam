extends Area2D

@export var witch_scene: PackedScene
var bruja_instance

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and bruja_instance == null:
		call_deferred("_spawn_bruja", body)

func _spawn_bruja(body):
	bruja_instance = witch_scene.instantiate()
	bruja_instance.position = Vector2(50, -8)
	get_parent().add_child(bruja_instance)

	if bruja_instance.has_method("play"):
		bruja_instance.play("idle")

	var dialogo = get_tree().get_first_node_in_group("DialogUI")
	dialogo.start([
		"Foolish mortal!",
		"I am the witch who rules this forest.",
		"Take this power... but be careful what you wish for.",
		'Press "L" or "X" to deactivate the power.'
	])



# ACTIVA EL PODER
	body.power_active = true
	body.set_collision_mask_value(body.GROUND_LAYER, false)
	body.set_collision_mask_value(body.SPECIAL_LAYER, true)
	body.sprite_normal.visible = false
	body.sprite_power.visible = true
	body.states_machine_normal.active = false
	body.states_machine_power.active = true
	body.can_move = false

	dialogo.dialogo_terminado.connect(func ():
		body.can_move = true
	)
