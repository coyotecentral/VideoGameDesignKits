extends Node2D

var player: Player = null

var keypress_tooltip_scene = preload("res://ui/button_tooltip/key_press.tscn")
var keypress_tooltip: Node2D

var button_press_tooltip_scene = preload("res://ui/button_tooltip/key_press.tscn")
var button_press_tooltip: Node2D

@export var popup: Control

# Called when the node enters the scene tree for the first time.
func _ready():
	keypress_tooltip = keypress_tooltip_scene.instantiate()
	keypress_tooltip.visible = false
	add_child(keypress_tooltip)

	button_press_tooltip = button_press_tooltip_scene.instantiate()
	button_press_tooltip.visible = false
	add_child(button_press_tooltip)

	$InteractionArea.body_entered.connect(func(body):
		if body is Player:
			player = body
	)

	$InteractionArea.body_exited.connect(func(body):
		if body is Player:
			player = null
	)

func hide_tooltip():
	button_press_tooltip.visible = false
	keypress_tooltip.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player:
		if Input.is_action_just_pressed("interact"):
			popup.visible = true
		# elif not popup.visible:
		#	pass
		else:
			if "SNES" in Input.get_joy_name(0) or "snes" in Input.get_joy_name(0):
				button_press_tooltip.visible = true
				button_press_tooltip.global_position = player.global_position + Vector2(0, -24)
			else:
				keypress_tooltip.visible = true
				keypress_tooltip.global_position = player.global_position + Vector2(0, -24)
	else:
		hide_tooltip()
		popup.visible = false
