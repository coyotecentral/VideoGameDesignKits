extends Path2D

@export var move_speed: float = 100.0
@export var wait_time: float = 0.0

# Looping: the platform moves to the last node, then goes backwards back to the
# 	starting node
# Cyclical: the platform moves to the first node once the terminal node is reached
# Terminal: the platform stops once it reaches the end
@export_enum("forward_backward", "loop")
var platform_type: String = "forward_backward"

# Positive -- forward. Negative -- backward
var direction = 1

var _target_position_idx = 0
var is_waiting = false
var _wait_timer: Timer

@onready var _follower: PathFollow2D = $PathFollow2D

signal point_reached

# Called when the node enters the scene tree for the first time.
func _ready():
	match platform_type:
		"loop":
			_follower.loop = true
		_:
			_follower.loop = false
	if(wait_time):
		_create_timer()
	point_reached.connect(_handle_point_reached)

func _physics_process(delta: float):
	if not is_waiting:
		_follower.progress += (move_speed * delta) * direction
	if _follower.position.distance_to(target_position()) < 1.0 or _follower.progress_ratio == 1.0:
		point_reached.emit()

func target_position() -> Vector2:
	return curve.get_point_position(_target_position_idx)

func _create_timer():
	is_waiting = true
	_wait_timer = Timer.new()
	_wait_timer.wait_time = wait_time
	_wait_timer.one_shot = true
	_wait_timer.timeout.connect(func():
		is_waiting = false
	)
	add_child(_wait_timer)
	_wait_timer.start()

func _handle_point_reached():
	match platform_type:
		"forward_backward":
			if _target_position_idx == curve.point_count - 1:
				direction = -1
			if _target_position_idx == 0:
				direction = 1
			_target_position_idx += direction
		"loop", _:
			if _target_position_idx == curve.point_count - 1:
				_target_position_idx = 0
			else:
				_target_position_idx += 1
	if(_wait_timer):
		is_waiting = true
		_wait_timer.start()