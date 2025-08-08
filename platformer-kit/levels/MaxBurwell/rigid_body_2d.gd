extends RigidBody2D


var initial_position: Vector2 = Vector2()
var _reset: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
# Replace with function body.
	freeze = true
	initial_position = global_position
	LevelController.register_entity_for_reset(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	 # Replace with function body.
	freeze = false

func _physics_process(delta: float) -> void:
	var bodies = get_colliding_bodies()
	for b in bodies:
		if b is Player:
			b.damage_taken.emit(1)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if _reset:
		linear_velocity = Vector2()
		global_transform = Transform2D(0.0, initial_position)
		angular_velocity = 0
		_reset = false
		set_deferred("freeze", true)
		$Timer.start()
	if freeze:
		linear_velocity = Vector2()
		angular_velocity = 0
		global_transform = Transform2D(0.0, initial_position)

func handle_reset():
	_reset = true
