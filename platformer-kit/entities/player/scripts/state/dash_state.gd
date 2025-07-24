extends CharacterState

@export_group("Transitions")
@export var fall_state: State

var dash_duration := 0.1
var upx_dash_dur := 0.3
var updash_dur := 0.15

var dash_start = false
var is_done = false
var movement: Vector2
var time: float = 0

var up_dash_vel = 250.0 * 4.5
var x_dash_vel = 250.0 * 7.0
var upx_dash_vel = 250.0 * 4.5

var velocity_falloff_time := 2.8
var updash_velocity_falloff := 1.0


func enter():
	super ()
	parent.dash_counter += 1
	time = 0
	movement = movement_controller.get_vector() * Vector2(1, -1)
	if not movement:
		if movement_controller.facing == "right":
			movement = Vector2.RIGHT
		elif movement_controller.facing == "left":
			movement = Vector2.LEFT
	is_done = false
	dash_start = true

func exit():
	movement = Vector2.ZERO
	is_done = false

func process_physics(delta: float) -> State:
	# Dash exit
	if movement.y == 0.0 and time >= dash_duration:
		#horiz dash exit
		return fall_state
	if movement.y < 0 and movement.x == 0.0 and time >= updash_dur:
		# Updash exit
		# if movement.y < 0:
		# 	parent.velocity.y = 0
		# return fall_state
		return fall_state
	elif movement.y < 0 and movement.x != 0.0 and time >= upx_dash_dur:
		return fall_state


	if dash_start:
		if movement == Vector2.UP:
			parent.velocity = movement * up_dash_vel
		elif movement.x:
			parent.velocity = movement.normalized() * upx_dash_vel
		elif movement.y == 0:
			parent.velocity = movement * x_dash_vel
		dash_start = false
	else:
		# Horiz dash out
		var sign = -1 if movement_controller.facing == "left" else 1
		var init_x_vel = parent.velocity.x
		var next_x_vel = init_x_vel * ease_out(min(time / velocity_falloff_time, 1.0))
		if movement_controller.get_vector().x != 0:
			# parent.velocity.x = max(next_x_vel, init_x_vel)
			parent.velocity.x = next_x_vel
		else:
			parent.velocity.x *= ease_out(min(time / velocity_falloff_time, 1.0))

		# falling
		if movement.y:
			parent.velocity.y *= ease_out(min(time / updash_velocity_falloff, 1.0))
		else:
			parent.velocity.y += parent.fall_gravity * delta
	parent.move_and_slide()
	time += delta
	return null

func ease_out(x: float) -> float:
	return pow(1 - x, 3)