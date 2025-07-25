extends CharacterState

@export_group("Transitions")
@export var jump_state: State
@export var fall_state: State

var buffer_time: float = 0.15
var time: float = 0
var wall_jump_start: bool = false

func enter():
	parent.velocity = Vector2.ZERO
	print("Enter wall grab")

func exit():
	time = 0
	wall_jump_start = false

func process_physics(delta: float) -> State:
	if movement_controller.is_jump_just_pressed() and not wall_jump_start:
		wall_jump_start = true
		if input_towards_wall():
			parent.velocity.y = parent.jump_velocity * 1.15
			parent.velocity.x = parent.float_speed * 2 * -check_direction()
		else:
			parent.velocity.y = parent.jump_velocity * 1.0
			parent.velocity.x = parent.float_speed * 1.5 * -check_direction()
		parent.move_and_slide()
		return fall_state
	
	if parent.is_on_floor():
		return fall_state
	
	if not input_towards_wall():
			time += delta
			if time >= buffer_time:
				return fall_state
			else:
				parent.velocity.y += parent.fall_gravity * delta
				parent.move_and_slide()
	else:
		time = 0
		parent.velocity.y = 50
		parent.move_and_slide()
	return null

func input_towards_wall() -> bool:
	var wall_direction = check_direction()
	var input_x = movement_controller.get_vector().x
	return sign(input_x * wall_direction) == 1

# Returns a value along the x-axis from -1 to 1
func check_direction() -> int:
	var controller = parent.get_node("InteractionController")
	var left_ray: InteractionRaycast = controller.left_middle
	var right_ray: InteractionRaycast = controller.right_middle
	if left_ray.is_colliding():
		return -1
	elif right_ray.is_colliding():
		return 1
	else:
		return 0