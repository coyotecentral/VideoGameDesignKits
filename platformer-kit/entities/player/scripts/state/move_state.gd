# Expect parent to be a CharacterBody2D
extends CharacterState

@export_group("Transitions")
@export var idle_state: State
@export var jump_state: State
@export var fall_state: State

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	var movement = movement_controller.get_vector().x * parent.move_speed

	if not parent.is_on_floor():
		return fall_state

	if movement_controller.is_jump_just_pressed():
		return jump_state

	# Transition back to idle if we're not moving at all
	if movement == 0:
		return idle_state

	parent.velocity.x = movement
	parent.move_and_slide()
	return null