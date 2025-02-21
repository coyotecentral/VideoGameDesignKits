extends Node2D

@export var map_speed := 24.0
@export var respawn_marker: Marker2D

var win_ui_scene = preload("res://ui/win_screen/win_screen.tscn")
var pause_ui_scene = preload("res://ui/pause_screen/pause_screen.tscn")

var pause_screen: CanvasLayer
var win_screen: CanvasLayer

var finished: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_screen = pause_ui_scene.instantiate()
	add_child(pause_screen)
	pause_screen.hide()
	LevelController._death_count += 1
	
	$CharacterBody2D.damage_taken.connect(func(_amntr):
		if get_tree():
			get_tree().reload_current_scene()
	)

func on_win_area_entered(body):
	if body is Player:
		LevelController.complete_level()
		win_screen = win_ui_scene.instantiate()
		add_child(win_screen)

func _process(delta):
	
	$CanvasLayer/DeathCount/HBoxContainer/Label.text = "x%d" % LevelController.get_death_count()
	
	if Input.is_action_just_pressed("open_menu"):
		if win_screen:
			win_screen.show()
			pause_screen.hide()
		if pause_screen:
			if not pause_screen.visible:
				pause_screen.show()
			else:
				pause_screen.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$TileMap.position += Vector2.LEFT * map_speed * delta
