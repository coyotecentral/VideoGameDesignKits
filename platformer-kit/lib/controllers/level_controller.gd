extends Node

@export var respawn_marker: Marker2D

var game_ui_scene = preload("res://ui/game_ui/game_ui.tscn")

var game_ui: GameUI
var _player: Player

signal respawn

func _ready():
	# Instantiate and add game ui
	game_ui = game_ui_scene.instantiate()
	add_child(game_ui)

	# Find the player and set it
	for c in get_children():
		if c is Player:
			_player = c
	
	# Set a respawn point if none is set
	if not respawn_marker:
		var marker = Marker2D.new()
		add_child(marker)
		marker.position = _player.position
		respawn_marker = marker
	
	LevelController.set_scene_path(scene_file_path)
	
	# Hack to see if it's the first time we're loading
	if LevelController._death_count <= 0:
		LevelController.set_spawn_position(respawn_marker.global_position)
	
	_player.respawn.emit()