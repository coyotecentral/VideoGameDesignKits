extends Node2D

@export var movement_controller: MovementController
@export var player: Player

@onready var middle_down: InteractionRaycast = $MiddleDown
@onready var hitbox_area: InteractionArea = $HitboxArea
# This ray checks if there are any ladders below us
@onready var ladder_down: InteractionRaycast = $LadderDown

func _ready() -> void:
	# Left-middle
	$LeftMiddle.set_handler(InteractionTypes.PushableObject, func(collider, delta):
		if movement_controller.facing == "left":
			InteractionHandlers.push_object(collider, Vector2( - 75.0, 0), delta)
	)
	$LeftMiddle.set_handler(InteractionTypes.Damage, func(_collider, _delta):
		InteractionHandlers.take_damage(player, 1)
	)

	# Left-lower
	$LeftLower.set_handler(InteractionTypes.Damage, func(_collider, _delta):
		InteractionHandlers.take_damage(player, 1)
	)


	# Right-middle
	$RightMiddle.set_handler(InteractionTypes.PushableObject, func(collider, delta):
		if movement_controller.facing == "right":
			InteractionHandlers.push_object(collider, Vector2(75.0, 0), delta)
	)
	$RightMiddle.set_handler(InteractionTypes.Damage, func(_collider, _delta):
		InteractionHandlers.take_damage(player, 1)
	)

	# Right-lower
	$RightLower.set_handler(InteractionTypes.Damage, func(_collider, _delta):
		InteractionHandlers.take_damage(player, 1)
	)

func _physics_process(delta: float) -> void:
	for c in get_children():
		if c is InteractionRaycast:
			c.process_collision(delta)

	# Legacy Code
	handle_down_middle(delta)
	handle_hitbox_area(delta)
	handle_ladder_down(delta)

func handle_hitbox_area(delta: float) -> void:
	var interaction_events := hitbox_area.get_interaction_events()

	var is_on_ladder = false
	# Try to see if we're overlapping a ladder area
	for area in hitbox_area.get_overlapping_areas():
		var parent = area.get_parent()
		if parent is Ladder:
			is_on_ladder = true
			player.climb_x_snap = parent.position.x
			break
	player.can_climb = is_on_ladder

	for event in interaction_events:
		match event.get_interaction_type():
			InteractionTypes.Gem:
				for gem in event.get_colliders():
					InteractionHandlers.collect_gem(player, gem)
			_:
				pass
	
func handle_down_middle(delta: float) -> void:
	var interaction_event = middle_down.process_collision(delta)
	var type = interaction_event.get_interaction_type()
	match type:
		InteractionTypes.Damage:
			InteractionHandlers.take_damage(player, 1)
		_:
			pass

func handle_ladder_down(delta: float) -> void:
	var interaction_event = ladder_down.process_collision(delta)
	var type = interaction_event.get_interaction_type()
	if type == InteractionTypes.Ladder:
		# This has to be global because this returns an Area2D
		player.climb_x_snap = interaction_event.get_collider().global_position.x
		player.can_climb_down = true
	else:
		player.can_climb_down = false