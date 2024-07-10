# Expect parent to be a CharacterBody2D
extends CharacterState

@export_group("Transitions")
@export var fall_state: State

func enter():
	super()
	parent.velocity = Vector2()

func process_physics(delta: float) -> State:
	var movement = movement_controller.get_vector().y * parent.climb_speed
	print(movement)

	if not parent.can_climb:
		return fall_state

	if movement_controller.is_jump_just_pressed():
		return fall_state

	if movement == 0:
		animations.pause()
	else:
		animations.play()
	
	parent.position.y -= movement * delta
	parent.move_and_slide()
	return null