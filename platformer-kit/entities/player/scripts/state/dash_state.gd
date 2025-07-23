extends CharacterState

@export_group("Transitions")
@export var fall_state: State

var dash_duration = 0.075
var is_done = false
var movement: Vector2

@onready var timer: Timer = Timer.new()

func _ready() -> void:
	add_child(timer)
	timer.timeout.connect(func():
		is_done = true
	)

func enter():
	super ()
	parent.dash_counter += 1
	movement = movement_controller.get_vector() * Vector2(1, -1)
	if not movement:
		if movement_controller.facing == "right":
			movement = Vector2.RIGHT
		elif movement_controller.facing == "left":
			movement = Vector2.LEFT
	is_done = false
	timer.wait_time = dash_duration
	timer.start()

func exit():
	movement = Vector2.ZERO
	is_done = false

func process_physics(delta: float) -> State:
	if is_done:
		if movement.y < 0:
			parent.velocity.y = 0
		return fall_state
	else:
		parent.velocity = movement * parent.move_speed * 3.0
	parent.move_and_slide()
	return null