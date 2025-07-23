extends RigidBody2D

var initial_position: Vector2
var _reset = false

@onready var shapecast: ShapeCast2D = $ShapeCast2D

func _ready():
	freeze = true
	initial_position = global_position
	LevelController.register_entity_for_reset(self)

func _process(delta: float):
	pass

func _physics_process(delta):
	linear_velocity.x = 0
	if shapecast.get_collision_count():
		for i in range(0, shapecast.get_collision_count()):
			_handle_shapecast_collision(shapecast.get_collider(i))

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

func _handle_shapecast_collision(collider: Node2D) -> void:
	if collider is Player:
		collider.damage_taken.emit(1)
	elif collider is EnemyBody2D:
		collider.death.emit()