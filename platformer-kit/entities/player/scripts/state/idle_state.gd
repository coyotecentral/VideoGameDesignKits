# Expect parent to be a CharacterBody2D
extends CharacterState

@export_group("Transitions")
@export var move_state: State
@export var jump_state: State
@export var fall_state: State
@export var climb_state: State

func process_physics(delta: float) -> State:
	if not parent.is_on_floor() and not parent.standing_on_ladder:
		return fall_state
	if movement_controller.is_climb_pressed() and parent.can_climb:
		return climb_state
	if movement_controller.get_vector().x:
		return move_state
	if movement_controller.is_jump_pressed():
		return jump_state
	parent.velocity = Vector2()
	parent.move_and_slide()
	return null
