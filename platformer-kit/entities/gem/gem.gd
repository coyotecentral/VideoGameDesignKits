extends Node2D
class_name Gem

@onready var animations = $AnimationPlayer

var is_collected = false

func collect():
	is_collected = true
	animations.play("collect")