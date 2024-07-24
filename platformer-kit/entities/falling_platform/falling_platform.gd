extends RigidBody2D
class_name FallingPlatform

@export var wait_time := 1.0
@export var shake_start_time := 0.5
var _wait_timer: Timer
var interaction_area: Area2D
var did_fall := false

var initial_position: Vector2

func _ready():
	if wait_time > 0:
		_create_timer()

	interaction_area = $InteractionArea
	interaction_area.body_entered.connect(func(body):
		if body is Player:
			if _wait_timer:
				_wait_timer.start()
			else:
				set_deferred("freeze", false)
				set_deferred("did_fall", true)
	)
	freeze = true

	initial_position = global_position
	LevelController.register_entity_for_reset(self)

func _create_timer():
	_wait_timer = Timer.new()
	_wait_timer.wait_time = wait_time
	_wait_timer.one_shot = true
	_wait_timer.timeout.connect(func():
		set_deferred("freeze", false)
		set_deferred("did_fall", true)
		$Sprites.position = Vector2()
	)
	add_child(_wait_timer)

func _physics_process(delta: float):
	linear_velocity.x = 0
	if _wait_timer and not did_fall:
		if not _wait_timer.is_stopped() and _wait_timer.time_left <= shake_start_time:
			var diff = Vector2(randf_range(-1, 1), randf_range(-1, 1))
			$Sprites.position = diff

func handle_reset():
	freeze = true
	$Sprites.position = Vector2()