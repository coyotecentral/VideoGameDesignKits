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
	initial_position = global_position
	LevelController.register_entity_for_reset(self)

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
	state_machine.change_state(death_state)

func handle_reset():
	set_collision_layer_value(1, true)
	set_collision_layer_value(2, true)
	set_collision_mask_value(1, true)
	animations.play("RESET")
	state_machine.change_state(state_machine.starting_state)
	visible = true