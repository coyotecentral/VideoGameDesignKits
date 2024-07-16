extends Spike
class_name RetractableSpike

signal retract
signal reveal

@export var retracted_time = 2.0
@export var revealed_time = 1.0
@export var retract_speed = 0.25
@export var reveal_speed = 0.075
var is_retracted = false
# Determines if the spike is visible
var is_enabled = true
var timer: Timer

func _ready():
	retract.connect(func():
		if not is_retracted:
			$AnimationPlayer.play("retract", -1, 1.0 / retract_speed)
			is_retracted = true
	)

	reveal.connect(func():
		if is_retracted:
			$AnimationPlayer.play("reveal", -1, 1.0 / reveal_speed)
			is_retracted = false
	)

	timer = Timer.new()
	timer.wait_time = retracted_time
	timer.one_shot = true
	timer.timeout.connect(func():
		if is_retracted:
			reveal.emit()
		else:
			retract.emit()
	)

	add_child(timer)
	timer.start()

func _process(_delta):
	if not $AnimationPlayer.is_playing() and timer.time_left == 0:
		start_timer()

func start_timer():
	if is_retracted:
		timer.wait_time = retracted_time
	else:
		timer.wait_time = revealed_time
	timer.start()