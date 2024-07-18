extends StateMachine
class_name CharacterStateMachine

@export var debug: bool = false
@export var animations: AnimationPlayer
@export var movement_controller: MovementController


func init(p) -> void:
	for child in get_children():
		child.animations = animations
		child.movement_controller = movement_controller
	super(p)
	for child in get_children():
		child.init()