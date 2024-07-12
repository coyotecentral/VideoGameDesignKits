extends Control

@export var quit_button: Button


# Called when the node enters the scene tree for the first time.
func _ready():
	quit_button.pressed.connect(func():
		get_tree().quit()
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
