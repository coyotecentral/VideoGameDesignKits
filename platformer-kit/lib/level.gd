extends Node2D
class_name Level

@export var respawn_marker: Marker2D
var timer: Timer

var game_ui_scene = preload("res://ui/game_ui/game_ui.tscn")
var win_ui_scene = preload("res://ui/win_screen/win_screen.tscn")
var pause_ui_scene = preload("res://ui/pause_screen/pause_screen.tscn")

var game_ui: GameUI
var pause_screen: CanvasLayer
var win_screen: CanvasLayer
var _player: Player

signal respawn

func _ready():
	# Instantiate and add game ui
	game_ui = game_ui_scene.instantiate()
	add_child(game_ui)

	pause_screen = pause_ui_scene.instantiate()
	add_child(pause_screen)
	pause_screen.hide()

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
	
	timer = Timer.new()
	timer.one_shot = false
	timer.wait_time = 1.0
	timer.timeout.connect(LevelController.increment_time.bind(1))
	add_child(timer)
	timer.start()
	
	LevelController.set_scene_path(scene_file_path)
	
	# Hack to see if it's the first time we're loading
	if LevelController._death_count <= 0:
		LevelController.set_spawn_position(respawn_marker.global_position)
	
	_player.respawn.emit()

func _process(delta: float):
	if LevelController.is_gems_completed() and not win_screen:
		LevelController.complete_level()
		win_screen = win_ui_scene.instantiate()
		add_child(win_screen)
	
	# if pause_screen and pause_screen.visible:
	# 	game_ui.visible = false
	# else:
	# 	game_ui.visible = true
	
	if Input.is_action_just_pressed("open_menu"):
		if win_screen:
			win_screen.show()
			pause_screen.hide()
		if pause_screen:
			if not pause_screen.visible:
				pause_screen.show()
			else:
				pause_screen.hide()