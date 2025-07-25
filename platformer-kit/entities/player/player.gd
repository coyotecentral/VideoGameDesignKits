extends CharacterBody2D
class_name Player

var manual_override: bool = false

@onready var state_machine: CharacterStateMachine = $StateMachine

@export_group("Movement")
@export var move_speed := 250.0
@export var float_speed := 150.0
@export var climb_speed := 150.0
@export var accel_time := 0.4
@export var deccel_time := 0.2

# The player accelerates at a linear rate
var accel_step: float:
	get:
		return move_speed / accel_time
var deccel_step: float:
	get:
		return move_speed / deccel_time

@export_group("Jumping")
@export var jump_height := 64.0
@export var jump_time_to_peak := 0.5
@export var jump_time_to_fall := 0.35
@export var coyote_time := 0.05

@export_group("Misc")
@export var max_fall_time := 5.0

# Calculate the gravity based on how we want the jump to feel
@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_fall * jump_time_to_fall)) * -1.0

# Supplemental state variables
var can_climb := false
var can_climb_down := false
var climb_x_snap: float = 0
var jump_counter := 0
var dash_counter: int = 0
var max_dashes := 1
@export var max_jumps := 2

signal respawn
signal damage_taken(amount: int)
signal gem_collected
signal key_collected
signal fall_start
signal fall_end
signal enemy_bounce
signal max_fall_time_elapsed

func _ready() -> void:
	state_machine.init(self)

	gem_collected.connect(func():
		LevelController.increment_score()
	)

	key_collected.connect(func():
		LevelController.increment_key_count()
	)

	damage_taken.connect(func(_amount: int):
		LevelController.respawn()
	)

	respawn.connect(func():
		velocity = Vector2()
		if LevelController.get_death_count() >= 0:
			LevelController.reset_entities()
		LevelController.increment_death_count()
		if LevelController.get_death_count() > 0:
			global_position = LevelController._respawn_position
	)

func _unhandled_input(event: InputEvent) -> void:
	if not manual_override:
		state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	if not manual_override:
		state_machine.process_physics(delta)

func _process(delta: float) -> void:
	if manual_override:
		state_machine.process_frame(delta)