extends CharacterStateMachine
class_name PlayerStateMachine

@export var damage_state: State

func init(p) -> void:
	super(p)
	p.damage_taken.connect(func (amount: int):
		change_state(damage_state)
	)
