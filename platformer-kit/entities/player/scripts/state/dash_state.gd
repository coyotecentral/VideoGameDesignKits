extends CharacterState

@export_group("Transitions")
@export var fall_state: State

var dash_duration := 0.2
var upx_dash_dur := 0.3
var updash_dur := 0.15

var dash_start = false
var is_done = false
var movement: Vector2
var time: float = 0

var up_dash_vel = 250.0 * 4.5
var x_dash_vel = 250.0 * 7.0
var upx_dash_vel = 250.0 * 4.5

var upx_vel_falloff := 3.5
# var x_vel_falloff := 2.8
var x_vel_falloff := 2.8
var updash_velocity_falloff := 1.0

var camera_shake := false
var camera: Camera2D
var init_camera_pos: Vector2
var init_camera_position_smoothing: bool

var shakes: int = 0
var max_shakes: int = 6


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

	camera = get_viewport().get_camera_2d()
	if camera:
		init_camera_position_smoothing = camera.position_smoothing_enabled
		init_camera_pos = camera.position
		if camera_shake:
			camera.position_smoothing_enabled = false
	shakes = 0

func exit():
	movement = Vector2.ZERO
	is_done = false
	if camera and camera_shake:
		camera.position = init_camera_pos
		camera.position_smoothing_enabled = init_camera_position_smoothing

func process_physics(delta: float) -> State:
	# Camera shake
	if camera_shake:
		if shakes < max_shakes:
			var shake_magnitude = 2
			camera.position = init_camera_pos + Vector2(randf() * shake_magnitude, randf() * shake_magnitude)
			shakes += 1
		else:
			camera.position = init_camera_pos

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
	elif time >= max(updash_dur, upx_dash_dur, dash_duration):
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
		var sign = -1 if movement_controller.facing == "left" else 1
		var init_x_vel = parent.velocity.x
		var next_x_vel = init_x_vel * cube_ease_out(min(time / upx_vel_falloff, 1.0))

		if movement.x != 0 && movement.y < 0:
			# Updash out
			parent.velocity.x *= cube_ease_out(min(time / upx_vel_falloff, 1.0))
		else:
			# Horiz dash
			parent.velocity.x *= cube_ease_out(min(time / x_vel_falloff, 1.0))

		# falling
		if movement.y < 0:
			parent.velocity.y *= cube_ease_out(min(time / updash_velocity_falloff, 1.0))
		elif movement.y > 0:
			# down dash
			parent.velocity.y *= cube_ease_out(min(time / updash_velocity_falloff, 1.0))
		elif movement.x and time < 0.02:
			parent.velocity.y = 0
		else:
			parent.velocity.y += parent.fall_gravity * delta
	parent.move_and_slide()
	time += delta
	return null

func cube_ease_out(x: float) -> float:
	return pow(1 - x, 3)

func quad_ease_out(x: float) -> float:
	return pow(1 - x, 2)

func exp_ease_out(x: float) -> float:
	return sqrt(1 - x)