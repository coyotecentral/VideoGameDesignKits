extends CharacterBody2D
class_name EnemyBody2D

@export var state_machine: EnemyStateMachine
@export var animations: AnimationPlayer
@export var death_state: CharacterState
@export var respawnable := true

var initial_position: Vector2

signal death

func _ready() -> void:
	state_machine.init(self)
	death.connect(_on_death)
	add_to_group("enemies")
	initial_position = global_position

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func _on_death():
	set_collision_layer_value(1, false)
	set_collision_layer_value(2, false)
	set_collision_mask_value(1, false)
	if (respawnable):
		LevelController.register_enemy_for_respawn(self)
	state_machine.change_state(death_state)