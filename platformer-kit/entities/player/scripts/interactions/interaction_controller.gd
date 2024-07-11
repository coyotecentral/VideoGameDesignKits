extends Node2D

@export var movement_controller: MovementController
@export var player: Player

@onready var middle_right: InteractionRaycast = $MiddleRight
@onready var middle_left: InteractionRaycast = $MiddleLeft
@onready var middle_down: InteractionRaycast = $MiddleDown
@onready var hitbox_area: InteractionArea = $HitboxArea
# This ray checks if there are any ladders below us
@onready var ladder_down: InteractionRaycast = $LadderDown

func _physics_process(delta: float) -> void:
	handle_left_middle(delta)
	handle_right_middle(delta)
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
	
func handle_left_middle(delta: float) -> void:
	var interaction_event = middle_left.process_collision()
	match interaction_event.get_interaction_type():
		InteractionTypes.PushableObject:
			# Only push when facing
			if(movement_controller.facing == "left"):
				InteractionHandlers.push_object(Vector2(-100.0, 0), interaction_event, delta)
		InteractionTypes.Damage:
			InteractionHandlers.take_damage(player, 1)
		_:
			pass

func handle_right_middle(delta: float) -> void:
	var interaction_event = middle_right.process_collision()
	match interaction_event.get_interaction_type():
		InteractionTypes.PushableObject:
			# Only push when facing
			if(movement_controller.facing == "right"):
				InteractionHandlers.push_object(Vector2(100.0, 0), interaction_event, delta)
		InteractionTypes.Damage:
			InteractionHandlers.take_damage(player, 1)
		_:
			pass
	
func handle_down_middle(delta: float) -> void:
	var interaction_event = middle_down.process_collision()
	var type = interaction_event.get_interaction_type()
	match type:
		InteractionTypes.Damage:
			InteractionHandlers.take_damage(player, 1)
		_:
			pass

func handle_ladder_down(delta: float) -> void:
	var interaction_event = ladder_down.process_collision()
	var type = interaction_event.get_interaction_type()
	if type == InteractionTypes.Ladder:
		# This has to be global because this returns an Area2D
		player.climb_x_snap = interaction_event.get_collider().global_position.x
		player.can_climb_down = true
	else:
		player.can_climb_down = false