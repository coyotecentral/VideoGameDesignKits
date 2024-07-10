extends CanvasLayer
class_name GameUI

@export var level_timer: Timer
@onready var timer_label: Label = $UI/Container/Timer/Label
@onready var gem_count_label: Label = $UI/Container/GemCount/HBoxContainer/Label
@onready var death_count_label: Label = $UI/Container/DeathCount/HBoxContainer/Label
var death_count: int = 0
var gem_count: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	if not level_timer:
		timer_label.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	gem_count_label.text = "x %d" % gem_count
	death_count_label.text = "x %d" % death_count
