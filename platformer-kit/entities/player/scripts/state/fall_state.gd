# Expect parent to be a CharacterBody2D
extends CharacterState

@export_group("Transitions")
@export var idle_state: State
@export var move_state: State
@export var climb_state: State

var queue_enemy_bounce := false

func init():
	super()
	parent.enemy_bounce.connect(func():
		queue_enemy_bounce = true
	)

func enter():
	super()
	parent.fall_start.emit()

func exit():
	super()
	parent.fall_end.emit()

func process_physics(delta: float) -> State:
	# Hacky way of making sprite face the right direction
	animations.play("%s_%s" % [animation_name, movement_controller.facing])
	parent.velocity.y += parent.fall_gravity * delta
	var movement = movement_controller.get_vector().x * parent.float_speed
	parent.velocity.x = movement
	parent.move_and_slide()

	if movement_controller.get_vector().y and parent.can_climb:
		return climb_state

	if parent.is_on_floor():
		if movement_controller.get_vector().x:
			return move_state
		else:
			return idle_state
	
	return null