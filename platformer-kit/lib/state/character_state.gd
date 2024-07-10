# Expect parent to be a CharacterBody2D
extends State
class_name CharacterState

@export var animation_name: String
# If true, the animations will be looked up with `*_left` and `*_right` suffixes accordingly
@export var directional: bool = true
var animations: AnimationPlayer
var movement_controller: MovementController

func enter() -> void:
	# Start playing a new animation if applicable
	if directional:
		animations.play("%s_%s" % [animation_name, movement_controller.facing])
	else:
		animations.play("%s" % animation_name)
