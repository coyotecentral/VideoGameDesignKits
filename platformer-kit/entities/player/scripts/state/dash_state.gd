extends CharacterState

@export_group("Transitions")
@export var fall_state: State

var dash_sprite = preload("uid://b1cuox0n447my")
var ghost_sprite = preload("uid://c0g0cwdtk8gvh")
var particle_scene = preload("uid://bkc6xt46ergnm")

var dash_duration := 0.2
var upx_dash_dur := 0.3
var updash_dur := 0.15

var dash_start = false
var is_done = false
var movement: Vector2
var time: float = 0
var last_ghost_time := 0.0
var max_ghosts = 4
var ghost_count = 0
var ghost_spacing = 0.05

var up_dash_vel = 250.0 * 2.5
var x_dash_vel = 250.0 * 2.5
var upx_dash_vel = 250.0 * 3.0

var upx_vel_falloff := 3.5
var x_vel_falloff := 2.8
var updash_velocity_falloff := 1.5

var camera_shake := true
var camera: Camera2D
var init_camera_pos: Vector2
var init_camera_position_smoothing: bool

var shakes: int = 0
var max_shakes: int = 5


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
	var instance = dash_sprite.instantiate()
	instance.global_position = parent.global_position + movement * 8
	instance.rotation = movement.angle()
	get_tree().get_root().add_child(instance)
	ghost_count = 0

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
	if time == 0.0 or time - last_ghost_time >= ghost_spacing and ghost_count < max_ghosts:
		var ghost = ghost_sprite.instantiate()
		if movement_controller.facing == "left":
			ghost.flip_h = true
		ghost.global_position = parent.global_position
		get_tree().get_root().add_child(ghost)
		last_ghost_time = time
		ghost_count += 1

		if ghost_count > 1 and ghost_count < max_ghosts:
			var particles = particle_scene.instantiate()
			particles.global_position = parent.global_position
			var emitter: CPUParticles2D = particles.get_node("CPUParticles2D")
			emitter.direction = movement * -1.0
			get_tree().get_root().add_child(particles)
	# Camera shake
	if camera_shake:
		if shakes < max_shakes:
			var shake_magnitude = 2
			var s
			if shakes % 2 == 0:
				s = 1
			else:
				s = -1
			camera.position = init_camera_pos + movement.normalized() * shake_magnitude * s
			shakes += 1
		else:
			camera.position = init_camera_pos

	# Dash exit
	if movement.y == 0.0 and time >= dash_duration:
		#horiz dash exit
		return fall_state
	if movement.y < 0 and movement.x == 0.0 and time >= updash_dur:
		# Updash exit
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
		if movement.x != 0 && movement.y < 0:
			# Updash out
			parent.velocity.x *= cube_ease_out(min(time / upx_vel_falloff, 1.0))
		else:
			# Horiz dash
			var next_vel = parent.velocity.x * cube_ease_out(min(time / x_vel_falloff, 1.0))
			parent.velocity.x = max(abs(next_vel), parent.float_speed) * sign(parent.velocity.x)

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