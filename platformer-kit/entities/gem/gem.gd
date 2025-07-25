extends Node2D
class_name Gem

@onready var animations = $AnimationPlayer

@export var reset_on_respawn := false

var is_collected = false
var initial_position: Vector2

func _ready():
	initial_position = global_position
	LevelController.register_gem(self)
	if reset_on_respawn:
		
		LevelController.register_entity_for_reset(self)

func collect():
	is_collected = true
	animations.play("collect")

func handle_reset():
	if is_collected:
		LevelController._gem_count -= 1
