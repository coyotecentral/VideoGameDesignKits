extends Node2D

@onready
var interaction_area = $InteractionArea

@onready
var animation_player = $AnimationPlayer

var is_pressed := false

signal pressed
signal released


# Called when the node enters the scene tree for the first time.
func _ready():
	$InteractionArea.body_entered.connect(_handle_body_entered)
	$InteractionArea.body_exited.connect(_handle_body_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _handle_body_entered(body: Node2D):
	if body is Player and not is_pressed:
		pressed.emit()
		is_pressed = true
		$AnimationPlayer.play("press")

func _handle_body_exited(body: Node2D):
	if body is Player and is_pressed:
		is_pressed = false
		released.emit()
		$AnimationPlayer.play("release")
