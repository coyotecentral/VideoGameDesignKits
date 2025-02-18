extends RigidBody2D

var initial_position: Vector2

func _ready():
	freeze = true

	initial_position = global_position
	LevelController.register_entity_for_reset(self)

func _process(delta: float):
	print(global_position)
	print("--")

func _physics_process(delta):
	linear_velocity.x = 0

func unfreeze():
	if freeze:
		set_deferred("freeze", false)
		# Hey why do I need this
		global_position = initial_position

func handle_reset():
	freeze = true
	linear_velocity = Vector2()
