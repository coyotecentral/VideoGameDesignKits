extends Node2D
class_name Ladder

@onready var area: Area2D = $Area2D
@onready var exit_ladder_area: Area2D = $ExitLadderArea
@onready var up_check: RayCast2D = $Up
@onready var down_check: RayCast2D = $Down
@onready var static_body: StaticBody2D = $StaticBody2D

var _contiguous_checked := false

func _ready():
	pass

func _process(delta: float):
	if not _contiguous_checked:
		make_contiguous()

func make_contiguous():
	_contiguous_checked = true
	var c = up_check.get_collider()
	var collider: Node2D
	if c is Area2D:
		collider = c.get_parent()
	else:
		collider = c
	if collider is Ladder:
		static_body.queue_free()
	
	var d = down_check.get_collider()
	var down_collider: Node2D
	if d is Area2D:
		down_collider = d.get_parent()
	else:
		down_collider = d

	if down_collider is Ladder:
		exit_ladder_area.queue_free()
	
	#clean up the rays
	up_check.queue_free()
	down_check.queue_free()