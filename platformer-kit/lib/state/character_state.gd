# Expect parent to be a CharacterBody2D
extends State
class_name CharacterState

@export var animation_name: String
var animations: AnimationPlayer
var movement_controller: MovementController

func enter() -> void:
	# Start playing a new animation if applicable
	animations.play("%s_%s" % [animation_name, movement_controller.facing])
