extends MovementController
class_name PlayerMovementController

func get_vector() -> Vector2:
	var x_direction := Input.get_axis("left", "right")
	if x_direction > 0:
		facing = "right"
	elif x_direction < 0:
		facing = "left"
	return Vector2(x_direction, 0)

func is_jump_just_pressed() -> bool:
	return Input.is_action_just_pressed("jump")

func is_jump_pressed() -> bool:
	return Input.is_action_pressed("jump")