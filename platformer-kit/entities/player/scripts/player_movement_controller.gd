extends MovementController
class_name PlayerMovementController

@export var jump_buffer_time := 0.25
var _is_jump_queued = false
var _jump_buffer_timer: Timer

@export var dash_buffer_time := 0.25
var _is_dash_queued = false
var _dash_buffer_timer: Timer

var _dash_timeout := 0.0
var _dash_ready = true
@onready var _timer_dash_timeout: Timer = Timer.new()

func _ready():
	_jump_buffer_timer = Timer.new()
	_jump_buffer_timer.one_shot = true
	_jump_buffer_timer.timeout.connect(func():
		_is_jump_queued = false
	)
	add_child(_jump_buffer_timer)

	_dash_buffer_timer = Timer.new()
	_dash_buffer_timer.one_shot = true
	_dash_buffer_timer.timeout.connect(func():
		_is_dash_queued = false
	)
	add_child(_dash_buffer_timer)


	if _dash_timeout > 0:
		_timer_dash_timeout.one_shot = true
		_timer_dash_timeout.timeout.connect(func():
			_dash_ready = true
		)
	add_child(_timer_dash_timeout)


func get_vector() -> Vector2:
	var x_direction := Input.get_axis("left", "right")
	var y_direction := Input.get_axis("down", "up")
	if x_direction > 0:
		facing = "right"
	elif x_direction < 0:
		facing = "left"
	return Vector2(x_direction, y_direction)

func _physics_process(delta: float):
	if Input.is_action_just_pressed("jump"):
		_start_jump_buffer()
	if Input.is_action_just_pressed("dash"):
		_start_dash_buffer()

func is_jump_just_pressed() -> bool:
	_jump_buffer_timer.stop()
	var result = _is_jump_queued
	_is_jump_queued = false
	return result

func is_jump_pressed() -> bool:
	return Input.is_action_pressed("jump")

func _start_jump_buffer() -> void:
	_is_jump_queued = true
	_jump_buffer_timer.wait_time = jump_buffer_time
	_jump_buffer_timer.start()

func is_climb_pressed() -> bool:
	return Input.is_action_pressed("up") or Input.is_action_just_pressed("down")

func is_dash_just_pressed() -> bool:
	_dash_buffer_timer.stop()
	var result = _is_dash_queued
	if not _dash_ready:
		return false
	elif result:
		if _dash_timeout > 0:
			_timer_dash_timeout.start()
			_dash_ready = false
		_is_dash_queued = false
		return true
	else:
		return result

func _start_dash_buffer() -> void:
	_is_dash_queued = true
	_dash_buffer_timer.wait_time = dash_buffer_time
	_dash_buffer_timer.start()