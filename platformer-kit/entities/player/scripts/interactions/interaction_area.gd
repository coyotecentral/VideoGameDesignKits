extends Area2D
class_name InteractionArea

@export var collide_with_bodies: bool = false

var _handlers: Dictionary = {}
func set_handler(key: String, handler: Callable) -> void:
	_handlers[key] = handler

# Sets the same handler for different interaction types
func set_handlers(names: Array, handler: Callable) -> void:
	for n in names:
		_handlers[n] = handler

func remove_handler(key: String) -> void:
	_handlers.erase(key)

# Expect to only interact with 1 area at a time
func get_interaction_event() -> InteractionEvent:
	if not has_overlapping_areas():
		return InteractionEvent.new(null, InteractionTypes.NoOp)
	# Get the first overlapping area
	var area = get_overlapping_areas()[0]
	var parent = area.get_parent()
	if parent is Gem:
		return InteractionEvent.new(parent, InteractionTypes.Gem)
	return InteractionEvent.new(null, InteractionTypes.NoOp)

func process_collision(delta: float) -> Array[InteractionEvent]:
	var result: Array[InteractionEvent] = []
	for area in get_overlapping_areas():
		var area_parent = area.get_parent()
		var event = _process_collision(area_parent)
		if event:
			result.push_back(event)
			_call_handler_for_event(event, delta)
	if collide_with_bodies:
		for body in get_overlapping_bodies():
			var event = _process_collision(body)
			if event:
				result.push_back(event)
				_call_handler_for_event(event, delta)
	return result

func _process_collision(collider: Node2D) -> InteractionEvent:
	var create_event = _create_event.bind(collider)
	var event: InteractionEvent
	if collider is Gem:
		event = create_event.call(InteractionTypes.Gem)
	if collider is Checkpoint:
		event = create_event.call(InteractionTypes.Checkpoint)
	if collider is Spike:
		event = create_event.call(InteractionTypes.Damage)
	if collider is Key:
		event = create_event.call(InteractionTypes.Key)
	if collider is Ladder:
		event = create_event.call(InteractionTypes.Ladder)
	if collider is EnemyBody2D:
		event = create_event.call(InteractionTypes.Enemy)

	return event

func _call_handler_for_event(event: InteractionEvent, delta: float):
	var type = event.get_interaction_type()
	if _handlers.has(type):
		var handler = _handlers[type]
		handler.call(event.get_collider(), delta)


func _create_event(type: String, collider: Node2D):
	return InteractionEvent.new(collider, type)