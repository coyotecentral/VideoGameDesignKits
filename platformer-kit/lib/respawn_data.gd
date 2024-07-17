class_name RespawnData

var entity: Node2D
var spawn_position: Vector2

func _init(node: Node2D, position: Vector2):
	entity = node
	spawn_position = position