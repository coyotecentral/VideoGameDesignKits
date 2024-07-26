extends CharacterBody2D
class_name MovableCrate

var initial_position: Vector2

func _ready() -> void:
	initial_position = global_position
	LevelController.register_entity_for_reset(self)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += 980 * delta
	else:
		velocity.y = 0
	move_and_slide()

func handle_reset():
	velocity = Vector2()