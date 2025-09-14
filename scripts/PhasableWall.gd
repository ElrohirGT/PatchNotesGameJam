extends StaticBody2D

@export var CAN_PHASE = false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_phase"):
		var collider: StaticBody2D = $"."
		CAN_PHASE = not CAN_PHASE
		if CAN_PHASE:
			collider.set_collision_mask_value(2, false)
		else:
			collider.set_collision_mask_value(2, true)
