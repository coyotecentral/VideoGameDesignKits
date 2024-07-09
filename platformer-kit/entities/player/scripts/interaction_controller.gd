extends Node2D

enum CollisionType {
	PushableObject,
	NoOp
}

@onready var middle_right: RayCast2D = $MiddleRight

func _physics_process(delta: float) -> void:
	var collision_type = handle_collisions(middle_right)

	match collision_type:
		CollisionType.PushableObject:
			print("Need to push")
		_:
			pass

func handle_collisions(ray: RayCast2D) -> CollisionType:
	var collider = ray.get_collider()
	if collider:
		if collider is MovableCrate:
			return CollisionType.PushableObject
	return CollisionType.NoOp