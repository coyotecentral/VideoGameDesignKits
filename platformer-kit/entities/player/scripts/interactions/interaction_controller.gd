extends Node2D

@export var movement_controller: MovementController
@export var player: Player

@onready var middle_right: InteractionRaycast = $MiddleRight
@onready var middle_left: InteractionRaycast = $MiddleLeft
@onready var middle_down: InteractionRaycast = $MiddleDown

func _physics_process(delta: float) -> void:

	handle_left_middle(delta)
	handle_right_middle(delta)
	handle_down_middle(delta)
	
func handle_left_middle(delta: float) -> void:
	var interaction_event = middle_left.get_interaction_event()
	match interaction_event.get_interaction_type():
		InteractionTypes.PushableObject:
			# Only push when facing
			if(movement_controller.facing == "left"):
				InteractionHandlers.push_object(Vector2(-100.0, 0), interaction_event, delta)
		_:
			pass

func handle_right_middle(delta: float) -> void:
	var interaction_event = middle_right.get_interaction_event()
	match interaction_event.get_interaction_type():
		InteractionTypes.PushableObject:
			# Only push when facing
			if(movement_controller.facing == "right"):
				InteractionHandlers.push_object(Vector2(100.0, 0), interaction_event, delta)
		_:
			pass
	
func handle_down_middle(delta: float) -> void:
	var interaction_event = middle_down.get_interaction_event()
	match interaction_event.get_interaction_type():
		InteractionTypes.Damage:
			InteractionHandlers.take_damage(player, 1)
		_:
			pass