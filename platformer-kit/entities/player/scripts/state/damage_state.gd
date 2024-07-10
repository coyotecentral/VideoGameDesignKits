# Expect parent to be a CharacterBody2D
extends CharacterState

@export var idle_state: State


@onready var timer: Timer
var handle_exit := false
var invincible := false
var respawning := false

func _ready():
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = 0.5 # Respawn time
	add_child(timer)

func enter():
	super()
	timer.start()
	invincible = true

func exit():
	handle_exit = false
	timer.stop()
	invincible = false
	respawning = false


func process_physics(delta: float) -> State:
	if timer.time_left <= 0.1 and not respawning:
		respawning = true
		parent.respawn.emit()
	if timer.is_stopped():
		return idle_state
	return null