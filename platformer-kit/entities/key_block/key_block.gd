extends Node2D
class_name KeyBlock

var is_player_in_range := false

func _ready():
	$InteractionArea.body_entered.connect(func(body):
		if body is Player:
			is_player_in_range=true
	)
	$InteractionArea.body_exited.connect(func(body):
		if body is Player:
			is_player_in_range=false
	)

func _process(delta: float) -> void:
	if is_player_in_range:
		if Input.is_action_just_pressed("interact") and LevelController.get_key_count():
			$AnimationPlayer.current_animation = "unlock"
			LevelController.decrement_key_count()
		else:
			# TODO show interaction tooltip
			pass