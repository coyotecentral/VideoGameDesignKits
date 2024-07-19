extends ShapeCast2D
class_name InteractionShapeCast

var _handlers: Dictionary = {}

func set_handler(type: String, handler: Callable) -> void:
	_handlers[type] = handler

# Sets the same handler for different interaction types
func set_handlers(types: Array, handler: Callable) -> void:
	for n in types:
		_handlers[n] = handler

func remove_handler(type: String) -> void:
	_handlers.erase(type)

func process_collision(delta: float) -> Array[InteractionEvent]:
	var events: Array[InteractionEvent] = []
	for idx in get_collision_count():
		var process_result = _process_collision(get_collider(idx), delta)
		if process_result:
			events.push_back(process_result)
	return events

func _process_collision(collider: Node2D, delta: float) -> InteractionEvent:
	var create_event = _create_event.bind(collider)
	var event: InteractionEvent
	if collider:
		if collider is MovableCrate:
			event = create_event.call(InteractionTypes.PushableObject)
		if collider is Spike:
			event = create_event.call(InteractionTypes.Damage)
		if collider is Gem:
			event = create_event.call(InteractionTypes.Gem)
		if collider is StaticBody2D and collider.get_parent() is Ladder:
			event = create_event.call(InteractionTypes.Ladder)
		if collider is EnemyBody2D:
			event = create_event.call(InteractionTypes.Enemy)
		if collider is Area2D:
			var parent = collider.get_parent()
			if parent is Ladder:
				event = create_event.call(InteractionTypes.Ladder)
	
	if event:
		_call_handler_for_event(event, delta)
	return event

func _call_handler_for_event(event: InteractionEvent, delta: float):
	var type = event.get_interaction_type()
	if _handlers.has(type):
		var handler = _handlers[type]
		handler.call(event.get_collider(), delta)

func _create_event(type: String, collider: Node2D):
	return InteractionEvent.new(collider, type)