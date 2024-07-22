extends RayCast2D

@onready var player: Player = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	enabled = false
	player.max_fall_time_elapsed.connect(func():
		enabled = true
	)
	player.respawn.connect(func():
		enabled = false
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	if enabled and not get_collider():
		player.damage_taken.emit(1)