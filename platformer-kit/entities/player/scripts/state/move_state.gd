# Expect parent to be a CharacterBody2D
extends CharacterState

@export_group("Transitions")
@export var idle_state: State
@export var jump_state: State
@export var fall_state: State
@export var climb_state: State

var _coyote_timer: Timer
var _coyote_time_elapsed: bool = false

func _ready():
	_coyote_timer = Timer.new()
	_coyote_timer.one_shot = true
	_coyote_timer.timeout.connect(func ():
		_coyote_time_elapsed = true
		)
	add_child(_coyote_timer)

func exit():
	super()
	reset_coyote_time()


func process_physics(delta: float) -> State:

	var movement = movement_controller.get_vector().x

	# Ladders
	if movement_controller.is_climb_pressed() and parent.can_climb:
		return climb_state

	# Coyote Time
	if not parent.is_on_floor():
		if _coyote_time_elapsed or movement == 0:
			return fall_state
		elif _coyote_timer.is_stopped():
			start_coyote_time()
	

	#Jump
	if movement_controller.is_jump_just_pressed():
		return jump_state

	# Transition back to idle if we're not moving at all
	if movement == 0:
		return idle_state

	# Actual Movement
	var next_velocity = min(abs(parent.velocity.x) + parent.accel_step * delta, parent.move_speed)
	# Return 1.0 or -1.0
	parent.velocity.x = round(movement) * next_velocity
	parent.move_and_slide()
	return null

func reset_coyote_time():
	_coyote_time_elapsed = false
	_coyote_timer.stop()

func start_coyote_time():
	_coyote_timer.wait_time = parent.coyote_time
	_coyote_timer.start()

	