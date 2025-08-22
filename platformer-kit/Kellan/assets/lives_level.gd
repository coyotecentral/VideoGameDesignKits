extends Level

@export var lives: int = 10
@export var game_over_menu: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	if LevelController.get_death_count() >= lives:
		get_tree().change_scene_to_packed(game_over_menu)
