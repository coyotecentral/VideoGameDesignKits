# This is the base state for all states.
# By default, it does nothing
class_name State
extends Node

var parent: Node2D

func init() -> void:
	pass

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null
