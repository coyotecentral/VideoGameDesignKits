extends MovementController

@export var body: CharacterBody2D
@export var sprite: Sprite2D

@onready var down_right: RayCast2D = $Rays/down_right
@onready var down_left: RayCast2D = $Rays/down_left

var direction = 1

func get_vector() -> Vector2:

	var dl_collider = down_left.get_collider()
	var dr_collider = down_right.get_collider()

	if body.is_on_wall():
		direction *= - 1
	else:
		if not dl_collider or dl_collider is Spike:
			direction = 1
		if not dr_collider or dr_collider is Spike:
			direction = -1
	
	sprite.flip_h = direction < 0
	return Vector2(direction, 0)