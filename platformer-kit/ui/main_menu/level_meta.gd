extends Resource
class_name LevelMeta

@export var level_name: String
@export var author: String
@export var file: String
@export var scene_uid: String

func _init(name: String = "", creator: String = "", path: String = ""):
	level_name = name
	author = creator
	file = path
