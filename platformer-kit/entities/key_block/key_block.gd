extends Node2D
class_name KeyBlock

var player: Player = null

var keypress_tooltip_scene = preload ("res://ui/button_tooltip/key_press.tscn")
var button_press_tooltip_scene = preload ("res://ui/button_tooltip/button_press.tscn")
var key_hint_tooltip_scene = preload ("res://ui/key_required_tooltip/key_required_tooltip.tscn")
var keypress_tooltip: Node2D
var button_press_tooltip: Node2D
var key_hint_tooltip: Node2D

var is_closed = true

func _ready():
	keypress_tooltip = keypress_tooltip_scene.instantiate()
	keypress_tooltip.visible = false
	add_child(keypress_tooltip)

	button_press_tooltip = button_press_tooltip_scene.instantiate()
	button_press_tooltip.visible = false
	add_child(button_press_tooltip)

	key_hint_tooltip = key_hint_tooltip_scene.instantiate()
	key_hint_tooltip.visible = false
	add_child(key_hint_tooltip)

	$InteractionArea.body_entered.connect(func(body):
		if body is Player:
			player=body
	)
	$InteractionArea.body_exited.connect(func(body):
		if body is Player:
			player=null
	)

func handle_open():
	is_closed = false

func hide_tooltip():
	button_press_tooltip.visible = false
	keypress_tooltip.visible = false
	key_hint_tooltip.visible = false

func _process(_delta: float) -> void:
	if player and is_closed:
		if Input.is_action_just_pressed("interact") and LevelController.get_key_count():
			$AnimationPlayer.current_animation = "unlock"
			LevelController.decrement_key_count()
		elif LevelController.get_key_count() > 0:
			if "SNES" in Input.get_joy_name(0) or "snes" in Input.get_joy_name(0):
				button_press_tooltip.visible = true
				button_press_tooltip.global_position = player.global_position + Vector2(0, -24)
			else:
				keypress_tooltip.visible = true
				keypress_tooltip.global_position = player.global_position + Vector2(0, -24)
			key_hint_tooltip.visible = false
		else:
			button_press_tooltip.visible = false
			keypress_tooltip.visible = false
			key_hint_tooltip.visible = true
			key_hint_tooltip.global_position = player.global_position + Vector2(0, -24)
	else:
		hide_tooltip()