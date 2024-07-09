# Expect parent to be a CharacterBody2D
extends CharacterState

@export_group("Transitions")
@export var fall_state: State


func enter():
	super()
	parent.velocity.y = parent.jump_velocity

func process_physics(delta: float) -> State:
	# Hacky way to make character face the right direction
	animations.play("%s_%s" % [animation_name, movement_controller.facing])
	if not movement_controller.is_jump_pressed():
		# Short jump
		parent.velocity.y *= 0.6
		return fall_state
	
	parent.velocity.y += parent.jump_gravity * delta
	var movement = movement_controller.get_vector().x * parent.float_speed
	parent.velocity.x = movement
	parent.move_and_slide()

	if parent.velocity.y >= 0.0:
		return fall_state
	return null
	