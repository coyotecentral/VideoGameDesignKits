extends Node
class_name StateMachine

@export var starting_state: State
var current_state: State
var parent

func init(p) -> void:
	# Assign the parent to the state machine
	parent = p

	# Assign the parent to all children of the state machine
	for child in get_children():
		child.parent = p
	
	# Initialize the starting state
	change_state(starting_state)

func change_state(next_state: State) -> void:
	if current_state:
		current_state.exit()
	current_state = next_state
	current_state.enter()

func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)
	
func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)

func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
