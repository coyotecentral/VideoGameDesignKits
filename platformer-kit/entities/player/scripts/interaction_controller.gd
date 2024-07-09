extends Node2D

@onready var middle_right: RayCast2D = $MiddleRight
@onready var middle_left: RayCast2D = $MiddleLeft
@onready var middle_down: RayCast2D = $MiddleDown

func _physics_process(delta: float) -> void:
	var right_interaction_event = handle_collisions(middle_right)

	match right_interaction_event.get_interaction_type():
		InteractionTypes.PushableObject:
			var colliding_object = right_interaction_event.get_collider()
			colliding_object.position.x += 100.0 * delta
		_:
			pass
		
	var left_interaction_event = handle_collisions(middle_left)

	match left_interaction_event.get_interaction_type():
		InteractionTypes.PushableObject:
			var colliding_object = left_interaction_event.get_collider()
			colliding_object.position.x -= 100.0 * delta
		_:
			pass
		
	var down_collision_type = handle_collisions(middle_down)

	match down_collision_type:
		InteractionTypes.Damage:
			print("Need to damage")
		_:
			pass

func handle_collisions(ray: RayCast2D) -> InteractionEvent:
	var collider = ray.get_collider()
	if collider:
		if collider is MovableCrate:
			return InteractionEvent.new(collider, InteractionTypes.PushableObject)
		if collider is Spike:
			return InteractionEvent.new(collider, InteractionTypes.Damage)
	return InteractionEvent.new(collider, InteractionTypes.NoOp)