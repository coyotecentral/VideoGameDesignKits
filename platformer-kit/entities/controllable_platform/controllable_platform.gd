extends RigidBody2D

var initial_position: Vector2
var _reset = false

func _ready():
	freeze = true
	initial_position = global_position
	LevelController.register_entity_for_reset(self)

func _process(delta: float):
	pass

func _physics_process(delta):
	linear_velocity.x = 0

func unfreeze():
	if freeze:
		set_deferred("freeze", false)
		# Hey why do I need this
		# global_position = initial_position

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if _reset:
		linear_velocity = Vector2()
		global_transform = Transform2D(0.0, initial_position)
		_reset = false
		set_deferred("freeze", true)
	if freeze:
		linear_velocity = Vector2()
		global_transform = Transform2D(0.0, initial_position)

func handle_reset():
	_reset = true
