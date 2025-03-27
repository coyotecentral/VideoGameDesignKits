extends Node2D

var _respawn_point := Vector2()
var pause_ui_scene = preload("res://ui/pause_screen/pause_screen.tscn")
var pause_screen: CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	_respawn_point = $CharacterBody2D.position
	$CharacterBody2D.damage_taken.connect(func(_amt):
		tile_map.position.x = 0
		)
	$CharacterBody2D.respawn.connect(func():
		$CharacterBody2D.position = _respawn_point
	)
	
	pause_screen = pause_ui_scene.instantiate()
	add_child(pause_screen)
	pause_screen.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _processs(delta):
	if Input.is_action_just_pressed("open_menu"):
		if pause_screen:
			if not pause_screen.visible:
				pause_screen.show()
			else:
				pause_screen.hide()
	
@export var map_speed: float = 125.0
@export var tile_map: TileMap

func _physics_process(delta: float) -> void:
	tile_map.position.x -= map_speed * delta

func _handle_teleport(position: Vector2) -> void:
	tile_map.position -= position
