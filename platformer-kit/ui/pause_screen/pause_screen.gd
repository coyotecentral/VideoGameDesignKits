extends CanvasLayer

@export var resume_btn: Button
@export var quit_to_menu_btn: Button


# Called when the node enters the scene tree for the first time.
func _ready():
	resume_btn.pressed.connect(handle_continue_exploring)
	quit_to_menu_btn.pressed.connect(func():
		get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		Engine.time_scale = 0.0
	else:
		Engine.time_scale = 1.0

func format_time(seconds: int) -> String:
	var result = ""
	var minutes = seconds / 60
	var remainder = seconds - minutes * 60

	if minutes < 10:
		result += "0"
	result += "%d:" % minutes
	if remainder < 10:
		result += "0"
	result += "%d" % remainder
	return result

func handle_continue_exploring():
	hide()