# Expect parent to be a CharacterBody2D
extends CharacterState

@export_group("Transitions")
@export var move_state: State
@export var jump_state: State
@export var fall_state: State
@export var climb_state: State

func process_physics(delta: float) -> State:
	if not parent.is_on_floor():
		return fall_state

	if movement_controller.get_vector().y < 0 and parent.can_climb_down:
		parent.position.y += parent.climb_speed * delta
		return climb_state
	if movement_controller.is_climb_pressed() and parent.can_climb:
		return climb_state
	if movement_controller.get_vector().x:
		return move_state
	if movement_controller.is_jump_just_pressed():
		return jump_state
	
	# Decellerate
	# TODO: Move this into a separate state
	var next_velocity = abs(parent.velocity.x) - parent.deccel_step * delta
	parent.velocity.x = max(next_velocity, 0) if parent.velocity.x > 0 else min(-next_velocity, 0)
	parent.move_and_slide()
	return null
