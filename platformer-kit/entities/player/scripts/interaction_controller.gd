extends Node2D

enum CollisionType {
	PushableObject,
	Damage,
	NoOp
}

@onready var middle_right: RayCast2D = $MiddleRight
@onready var middle_down: RayCast2D = $MiddleDown

func _physics_process(delta: float) -> void:
	var collision_type = handle_collisions(middle_right)

	match collision_type:
		CollisionType.PushableObject:
			print("Need to push")
		_:
			pass
		
	var down_collision_type = handle_collisions(middle_down)

	match down_collision_type:
		CollisionType.Damage:
			print("Need to damage")
		_:
			pass

func handle_collisions(ray: RayCast2D) -> CollisionType:
	var collider = ray.get_collider()
	if collider:
		if collider is MovableCrate:
			return CollisionType.PushableObject
		if collider is Spike:
			return CollisionType.Damage
	return CollisionType.NoOp