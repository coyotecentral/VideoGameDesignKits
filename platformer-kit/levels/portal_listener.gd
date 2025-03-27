extends Node

@export var camera: Camera2D
@export var player: Player

func _handle_teleport(position):
	player.global_position = position