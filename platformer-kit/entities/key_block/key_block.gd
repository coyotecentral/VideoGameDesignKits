extends Node2D
class_name KeyBlock

var player: Player = null

var tooltip_scene = preload("res://ui/button_tooltip/key_press.tscn")
var tooltip: Node2D

var is_closed = true

func _ready():
	tooltip = tooltip_scene.instantiate()
	tooltip.visible=false
	add_child(tooltip)

	$InteractionArea.body_entered.connect(func(body):
		if body is Player:
			player = body
	)
	$InteractionArea.body_exited.connect(func(body):
		if body is Player:
			player = null
	)

func handle_open():
	is_closed = false

func hide_tooltip():
	tooltip.visible = false

func _process(delta: float) -> void:
	if player and is_closed:
		if Input.is_action_just_pressed("interact") and LevelController.get_key_count():
			$AnimationPlayer.current_animation = "unlock"
			LevelController.decrement_key_count()
		else:
			tooltip.visible=true
			tooltip.global_position = player.global_position + Vector2(0, -24)
	else:
		hide_tooltip()