extends CanvasLayer

@export var time_label: Label
@export var deaths_label: Label

@export var continue_exploring_btn: Button
@export var quit_to_menu_btn: Button


# Called when the node enters the scene tree for the first time.
func _ready():
	time_label.text = format_time(LevelController.get_final_time())
	deaths_label.text = "%d" % LevelController.get_final_death_count()

	continue_exploring_btn.pressed.connect(handle_continue_exploring)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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