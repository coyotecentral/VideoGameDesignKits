extends Node2D
class_name Checkpoint

var active_sprite = preload("res://entities/checkpoint/sprites/checkpoint_active.png")
var inactive_sprite = preload("res://entities/checkpoint/sprites/checkpoint_inactive.png")

@onready var respawn_marker: Marker2D = $Marker2D
@onready var sprite: Sprite2D = $Sprite2D

var is_active = false

func _process(delta):
	if is_active:
		sprite.texture = active_sprite
	else:
		sprite.texture = inactive_sprite

func set_active():
	is_active = true
	LevelController.set_checkpoint(respawn_marker.global_position)