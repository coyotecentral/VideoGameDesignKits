extends CanvasLayer
class_name GameUI

@export var level_timer: Timer
@onready var timer_label: Label = $UI/Container/Timer/Label
@onready var gem_count_label: Label = $UI/Container/GemCount/HBoxContainer/Label
@onready var death_count_label: Label = $UI/Container/DeathCount/HBoxContainer/Label


# Called when the node enters the scene tree for the first time.
func _ready():
	if not level_timer:
		timer_label.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	gem_count_label.text = "x %d" % LevelController.get_gem_count()
	death_count_label.text = "x %d" % LevelController.get_death_count()
