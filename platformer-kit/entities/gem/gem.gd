extends Node2D
class_name Gem

@onready var animations = $AnimationPlayer

var is_collected = false

func _ready():
	LevelController.register_gem(self)

func collect():
	is_collected = true
	animations.play("collect")
