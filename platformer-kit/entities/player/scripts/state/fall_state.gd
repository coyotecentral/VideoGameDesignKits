# Expect parent to be a CharacterBody2D
extends CharacterState

@export_group("Transitions")
@export var idle_state: State
@export var move_state: State
@export var climb_state: State
@export var jump_state: State
@export var dash_state: State

var queue_enemy_bounce := false
var max_fall_timer: Timer

func init():
	super ()
	parent.enemy_bounce.connect(func():
		queue_enemy_bounce = true
	)

	max_fall_timer.wait_time = parent.max_fall_time
	max_fall_timer.timeout.connect(func():
		parent.max_fall_time_elapsed.emit()
	)

func _ready():
	max_fall_timer = Timer.new()
	max_fall_timer.one_shot = true
	add_child(max_fall_timer)
	

func enter():
	super ()
	parent.fall_start.emit()
	max_fall_timer.wait_time = parent.max_fall_time
	max_fall_timer.start()

func exit():
	super ()
	max_fall_timer.stop()
	parent.fall_end.emit()

func process_physics(delta: float) -> State:
	# Hacky way of making sprite face the right direction
	animations.play("%s_%s" % [animation_name, movement_controller.facing])
	parent.velocity.y += parent.fall_gravity * delta

	#
	var movement = movement_controller.get_vector().x
	if movement:
		parent.velocity.x = lerp(parent.velocity.x, movement * parent.float_speed, 5 * delta)
	else:
		parent.velocity.x = lerp(parent.velocity.x, 0.0, delta)

	if movement_controller.is_jump_just_pressed() and \
		parent.jump_counter < parent.max_jumps \
		and parent.jump_counter >= 1: # Only double jump if we've jumped
		return jump_state

	if movement_controller.is_dash_just_pressed() and parent.dash_counter == 0:
		return dash_state

	parent.move_and_slide()

	if movement_controller.get_vector().y and parent.can_climb:
		return climb_state

	if parent.is_on_floor():
		if movement_controller.get_vector().x:
			parent.jump_counter = 0
			return move_state
		else:
			parent.jump_counter = 0
			return idle_state
	
	return null