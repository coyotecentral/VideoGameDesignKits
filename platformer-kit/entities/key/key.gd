extends Node2D
class_name Key

@onready var animations = $AnimationPlayer

var is_collected = false

func collect():
	is_collected = true
	animations.play("collect")