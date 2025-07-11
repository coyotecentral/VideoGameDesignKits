extends CharacterStateMachine
class_name EnemyStateMachine

func init(p) -> void:
	for child in get_children():
		child.movement_controller = movement_controller
	super(p)
