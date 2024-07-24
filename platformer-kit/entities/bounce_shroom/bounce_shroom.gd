extends Node2D
class_name BounceShroom

@onready var animations: AnimationPlayer = $AnimationPlayer

func bounce():
	animations.play()