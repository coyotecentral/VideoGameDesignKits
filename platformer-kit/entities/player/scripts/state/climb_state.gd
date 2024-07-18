# Expect parent to be a CharacterBody2D
extends CharacterState

@export_group("Transitions")
@export var idle_state: State
@export var fall_state: State

var dismount_count = 0

func enter():
	super()
	parent.velocity = Vector2()
	parent.position.x = parent.climb_x_snap + 2

func exit():
	super()
	dismount_count = 0

func process_physics(delta: float) -> State:
	var movement = movement_controller.get_vector().y * parent.climb_speed
	if not parent.can_climb and not parent.can_climb_down:
		return fall_state

	if movement_controller.is_jump_just_pressed():
		parent.velocity.y -= 200
		return fall_state

	if movement == 0:
		animations.pause()
	else:
		animations.play()
	
	if movement < 0 and parent.is_on_floor():
		dismount_count += 1
		if dismount_count > 2:
			return idle_state
	
	parent.position.y -= movement * delta
	parent.move_and_slide()
	return null