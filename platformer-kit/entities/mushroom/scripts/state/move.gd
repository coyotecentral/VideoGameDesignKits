extends CharacterState

var gravity = 980
var move_speed = 100

func enter():
	animations.speed_scale = 2.0
	super()

func exit():
	animations.speed_scale = 1.0
	super()

func process_physics(delta: float) -> State:
	if not parent.is_on_floor():
		parent.velocity.y += gravity * delta
	
	var movement = movement_controller.get_vector() * move_speed
	parent.velocity.x = movement.x
	parent.move_and_slide()

	return null