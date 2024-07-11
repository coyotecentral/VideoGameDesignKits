class_name RespawnData

var scene_file_path: String
var spawn_position: Vector2

func _init(path: String, position: Vector2):
	scene_file_path = path
	spawn_position = position