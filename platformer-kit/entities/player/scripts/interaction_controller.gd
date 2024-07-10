extends Node2D

@export var movement_controller: MovementController

@onready var middle_right: RayCast2D = $MiddleRight
@onready var middle_left: RayCast2D = $MiddleLeft
@onready var middle_down: RayCast2D = $MiddleDown

func _physics_process(delta: float) -> void:

	handle_left_middle(delta)
	handle_right_middle(delta)
	handle_down_middle(delta)
	
func handle_left_middle(delta: float) -> void:
	var interaction_event = get_ray_collision(middle_left)
	match interaction_event.get_interaction_type():
		InteractionTypes.PushableObject:
			# Only push when facing
			if(movement_controller.facing == "left"):
				handle_pushable_object(Vector2(-100.0, 0), interaction_event, delta)
		_:
			pass

func handle_right_middle(delta: float) -> void:
	var interaction_event = get_ray_collision(middle_right)
	match interaction_event.get_interaction_type():
		InteractionTypes.PushableObject:
			# Only push when facing
			if(movement_controller.facing == "right"):
				handle_pushable_object(Vector2(100.0, 0), interaction_event, delta)
		_:
			pass
	
func handle_down_middle(delta: float) -> void:
	var interaction_event = get_ray_collision(middle_down)
	match interaction_event.get_interaction_type():
		InteractionTypes.Damage:
			print("Need to damage")
		_:
			pass

func handle_pushable_object(force: Vector2, event: InteractionEvent, delta: float) -> void:
	var colliding_object = event.get_collider()
	colliding_object.position += force * delta
		

func get_ray_collision(ray: RayCast2D) -> InteractionEvent:
	var collider = ray.get_collider()
	if collider:
		if collider is MovableCrate:
			return InteractionEvent.new(collider, InteractionTypes.PushableObject)
		if collider is Spike:
			return InteractionEvent.new(collider, InteractionTypes.Damage)
	return InteractionEvent.new(collider, InteractionTypes.NoOp)