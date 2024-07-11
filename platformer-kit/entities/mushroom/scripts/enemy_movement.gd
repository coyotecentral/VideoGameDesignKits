extends MovementController

@export var body: CharacterBody2D
@export var sprite: Sprite2D

@onready var down_right: RayCast2D = $Rays/down_right
@onready var down_left: RayCast2D = $Rays/down_left

var direction = 1

func get_vector() -> Vector2:

	if body.is_on_wall():
		direction *= -1
	else:
		if not down_left.is_colliding():
			direction = 1
		if not down_right.is_colliding():
			direction = -1
	
	sprite.flip_h = direction < 0
	return Vector2(direction, 0)