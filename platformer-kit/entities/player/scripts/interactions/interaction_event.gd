extends Node
class_name InteractionEvent

var _collider: Node2D
var _type: String

# Expect type to be a constant defined in interaction_type.gd
func _init(collider: Node2D, type: String):
	_collider = collider
	_type = type

# Get the colliding object
func get_collider() -> Node2D:
	return _collider

func get_interaction_type() -> String:
	return _type