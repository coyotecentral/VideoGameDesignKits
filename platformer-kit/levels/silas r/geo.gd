extends CharacterBody2D

@export var speed: float = 400
@export var jump_height: float = 350
@export var fall_speed: float = 350

var _spawn_position: Vector2 = Vector2()
var state: String = "wait_for_input"

func _ready():
	_spawn_position = global_position
	

func _physics_process(delta: float) -> void:
	if state == "play":
		if Input.is_action_pressed("jump"):
			velocity.y = - jump_height
		else:
			velocity.y = fall_speed
		velocity.x = speed
	if state == "wait_for_input":
		velocity = Vector2()
		if Input.is_anything_pressed():
			state = "play"
		
	move_and_slide()
	for c_idx in get_slide_collision_count():
		var c = get_slide_collision(c_idx)
		if c.get_collider() is Spike or c.get_collider().get_parent() is Spike:
			global_position = _spawn_position
			state = "wait_for_input"
