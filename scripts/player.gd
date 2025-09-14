extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var MAX_FALL_SPEED = 1000
@export var PLAYER_GRAVITY = 10

@export var CAN_PHASE = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, MAX_FALL_SPEED, PLAYER_GRAVITY*delta)

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("toggle_phase"):
		var collider: CollisionObject2D = $"."
		CAN_PHASE = not CAN_PHASE
		if CAN_PHASE:
			collider.set_collision_mask_value(3, false)
			print("Phasing activated!")
		else:
			collider.set_collision_mask_value(3, true)
			print("Phasing deactivated!")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
