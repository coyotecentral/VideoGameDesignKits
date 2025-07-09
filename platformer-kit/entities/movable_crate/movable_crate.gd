extends CharacterBody2D
class_name MovableCrate

@onready var shapecast: ShapeCast2D = $ShapeCast2D
var initial_position: Vector2

func _ready() -> void:
	initial_position = global_position
	LevelController.register_entity_for_reset(self)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += 980 * delta
	move_and_slide()
	if shapecast.get_collision_count():
		for i in range(0, shapecast.get_collision_count()):
			_handle_shapecast_collision(shapecast.get_collider(i))

# Handle any event that would trigger the shapecast on the bottom
func _handle_shapecast_collision(collider: Node2D):
	if collider is EnemyBody2D:
		# Instant kill
		collider.death.emit()

func handle_reset():
	velocity = Vector2()