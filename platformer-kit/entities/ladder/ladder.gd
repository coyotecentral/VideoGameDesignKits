extends Node2D
class_name Ladder

@onready var area: Area2D = $Area2D
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
	print(c)
	var collider: Node2D
	if c is Area2D:
		print("Area")
		collider = c.get_parent()
	else:
		collider = c
	
	if collider is Ladder:
		print("making ladder contigous...")
		static_body.queue_free()
	
	#clean up the rays
	up_check.queue_free()
	down_check.queue_free()