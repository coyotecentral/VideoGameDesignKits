extends CanvasLayer
class_name GameUI

@onready var timer_label: Label = $UI/Container/Timer/Label
@onready var gem_count_label: Label = $UI/Container/GemCount/HBoxContainer/Label
@onready var death_count_label: Label = $UI/Container/DeathCount/HBoxContainer/Label
@onready var key_count_label: Label = $UI/Container/KeyCount/HBoxContainer/Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	gem_count_label.text = "%d / %d" % [LevelController.get_gem_count(), LevelController.get_total_gem_count()]
	death_count_label.text = "%d" % LevelController.get_death_count()
	key_count_label.text = "%d" % LevelController.get_key_count()
	timer_label.text = format_time(LevelController.get_seconds_elapsed())

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
