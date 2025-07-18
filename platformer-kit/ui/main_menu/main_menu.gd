extends Control

@export var quit_button: Button
@export var level_button_container: VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	quit_button.pressed.connect(func():
		get_tree().quit()
	)
	Engine.time_scale = 1.0
	LevelController.reset_variables()
	var first_btn := level_button_container.get_child(0)
	first_btn.grab_focus()

func _create_level_button(level: LevelMeta) -> Button:
	var btn = Button.new()
	btn.text = level.level_name
	btn.pressed.connect(func():
		get_tree().change_scene_to_file(level.file)
	)
	return btn