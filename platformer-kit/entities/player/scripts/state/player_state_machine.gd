extends CharacterStateMachine
class_name PlayerStateMachine

@export var damage_state: State
@export var jump_state: State

var queue_bounce = false

func init(p) -> void:
	super(p)
	p.damage_taken.connect(func (amount: int):
		if not damage_state.invincible:
			change_state(damage_state)
	)
	p.enemy_bounce.connect(func():
		queue_bounce = true
	)

func _physics_process(delta):
	if queue_bounce:
		change_state(jump_state)
		queue_bounce = false