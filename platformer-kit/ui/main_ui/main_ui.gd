extends CanvasLayer

@export var level_timer: Timer
@onready var timer_label: Label = $UI/Container/Timer/Label
@onready var gem_count_label: Label = $UI/Container/GemCount/HBoxContainer/Label
var heart_count: int = 3
var gem_count: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	if not level_timer:
		timer_label.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	gem_count_label.text = "x %d" % gem_count