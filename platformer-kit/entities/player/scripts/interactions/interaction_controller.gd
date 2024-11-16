extends Node2D

@export var movement_controller: MovementController
@export var player: Player

@onready var hitbox_area: InteractionArea = $HitboxArea
var hurtbox_delay_timer: Timer

func _ready() -> void:
	$LeftMiddle.set_handler(InteractionTypes.PushableObject, func(collider, delta):
		if movement_controller.facing == "left":
			InteractionHandlers.push_object(collider, Vector2( - 75.0, 0), delta)
	)

	$RightMiddle.set_handler(InteractionTypes.PushableObject, func(collider, delta):
		if movement_controller.facing == "right":
			InteractionHandlers.push_object(collider, Vector2(75.0, 0), delta)
	)
	
	$HitboxArea.set_handler(InteractionTypes.Gem, func(collider, _delta):
		InteractionHandlers.collect_gem(player, collider)
	)
	$HitboxArea.set_handler(InteractionTypes.Checkpoint, func(collider, _delta):
		collider.set_active()
	)
	$HitboxArea.set_handler(InteractionTypes.Key, func(collider, _delta):
		InteractionHandlers.collect_key(player, collider)
	)
	$HitboxArea.set_handler(InteractionTypes.Damage, func(_collider, _delta):
		InteractionHandlers.take_damage(player, 1)
	)
	$HitboxArea.set_handler(InteractionTypes.Enemy, func(collider, _delta):
		InteractionHandlers.take_damage(player, 1)
	)

	$HurtboxShapecast.set_handler(InteractionTypes.Enemy, func(collider, _delta):
		collider.death.emit()
		player.position.y = collider.global_position.y - 16
		player.enemy_bounce.emit()
	)

	hurtbox_delay_timer = Timer.new()
	hurtbox_delay_timer.one_shot = true
	add_child(hurtbox_delay_timer)
	hurtbox_delay_timer.timeout.connect(func():
		$HurtboxShapecast.enabled = false
	)

	player.fall_start.connect(enable_hurt_boxes)
	player.fall_end.connect(disable_hurt_boxes)

func enable_hurt_boxes() -> void:
	$HurtboxShapecast.enabled = true
	hurtbox_delay_timer.stop()

func disable_hurt_boxes() -> void:
	hurtbox_delay_timer.wait_time = 0.125
	hurtbox_delay_timer.start()

func _physics_process(delta: float) -> void:
	for c in get_children():
		if c is InteractionRaycast: 
			c.process_collision(delta)
		if c is InteractionArea:
			c.process_collision(delta)
	$HurtboxShapecast.process_collision(delta)

	var shapecast = $DownObjectShapecast
	var shapecast_events = shapecast.process_collision(delta)
	_handle_ladder_down(shapecast_events)
	_handle_ladders()

func _handle_ladders() -> void:
	var is_on_ladder = false
	# Try to see if we're overlapping a ladder area
	for area in hitbox_area.get_overlapping_areas():
		var parent = area.get_parent()
		if parent is Ladder:
			is_on_ladder = true
			player.climb_x_snap = parent.global_position.x
			break
	player.can_climb = is_on_ladder

func _handle_ladder_down(events: Array[InteractionEvent]) -> void:
	var can_climb_down = false
	for event in events:
		var type = event.get_interaction_type()
		if type == InteractionTypes.Ladder:
			# This has to be global because this returns an Area2D
			player.climb_x_snap = event.get_collider().global_position.x
			can_climb_down = true
	player.can_climb_down = can_climb_down