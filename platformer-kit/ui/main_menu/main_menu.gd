extends Control

@export var quit_button: Button
@export var levels: Array[LevelMeta] = []
@export var level_button_container: VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	quit_button.pressed.connect(func():
		get_tree().quit()
	)
	for level in levels:
		level_button_container.add_child(_create_level_button(level))
	Engine.time_scale = 1.0
	LevelController.reset_variables()
	var first_btn := level_button_container.get_child(0)
	first_btn.grab_focus()

func _create_level_button(level: LevelMeta) -> Button:
	var btn = Button.new()
	btn.text = "%s by %s" % [level.level_name, level.author]
	btn.pressed.connect(func():
		get_tree().change_scene_to_file(level.file)
	)
	return btn