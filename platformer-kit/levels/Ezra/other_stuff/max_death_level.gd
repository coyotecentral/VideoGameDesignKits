extends Level

@export var max_deaths: int = 10
@export var game_over_screen: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	if LevelController.get_death_count() > max_deaths - 1:
		get_tree().change_scene_to_packed(game_over_screen)
