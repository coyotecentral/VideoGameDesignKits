extends Node
class_name InteractionEvent

var _colliders: Array[Node2D] = []
var _type: String

# Expect type to be a constant defined in interaction_type.gd
func _init(collider: Node2D, type: String):
	_colliders.push_back(collider)
	_type = type

# Get the first colliding object
func get_collider(idx: int = 0) -> Node2D:
	return _colliders[idx]

func get_colliders() -> Array[Node2D]:
	return _colliders

func get_interaction_type() -> String:
	return _type