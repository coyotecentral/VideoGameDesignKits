extends CharacterBody2D
class_name Player

@onready var state_machine: CharacterStateMachine = $StateMachine

@export_group("Movement")
@export var move_speed := 250.0
@export var float_speed := 150.0

@export_group("Jumping")
@export var jump_height := 64.0
@export var jump_time_to_peak := 0.5
@export var jump_time_to_fall := 0.4
@export var coyote_time := 0.05

# Calculate the gravity based on how we want the jump to feel
@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * - 1
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * - 1.0
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_fall * jump_time_to_fall)) * - 1.0

signal respawn
signal damage_taken(amount: int)
signal gem_collected

func _ready() -> void:
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
