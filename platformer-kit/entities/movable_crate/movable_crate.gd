extends AnimatableBody2D
class_name MovableCrate

@onready var shape_cast_right: ShapeCast2D = $RightShapeCast

var velocity := Vector2()


func _physics_process(delta: float) -> void:
	if not is_grounded():
		velocity.y += 980 * delta
	else:
		velocity.y = 0
	var collision = move_and_collide(velocity * delta)

func is_grounded() -> bool:
	return false