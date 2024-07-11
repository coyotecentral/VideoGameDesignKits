extends RayCast2D
class_name InteractionRaycast

var _handlers: Dictionary = {}

func set_handler(name: String, handler: Callable) -> void:
	_handlers[name] = handler

func remove_handler(name: String) -> void:
	_handlers.erase(name)


func process_collision(delta: float) -> InteractionEvent:
	var collider = get_collider()
	var call_handler = _call_handler_by_key_if_exists.bind(delta).bind(collider)
	var create_event = _create_event.bind(collider)
	if collider:
		if collider is MovableCrate:
			call_handler.call(InteractionTypes.PushableObject)
			return create_event.call(InteractionTypes.PushableObject)
		if collider is Spike:
			call_handler.call(InteractionTypes.Damage)
			return create_event.call(InteractionTypes.Damage)
		if collider is Gem:
			call_handler.call(InteractionTypes.Gem)
		if collider is StaticBody2D and collider.get_parent() is Ladder:
			call_handler.call(InteractionTypes.Ladder)
			return create_event.call(InteractionTypes.Ladder)
		if collider is Area2D:
			var parent = collider.get_parent()
			if parent is Ladder:
				call_handler.call(InteractionTypes.Ladder)
				return create_event.call(InteractionTypes.Ladder)
	return InteractionEvent.new(collider, InteractionTypes.NoOp)

func _call_handler_by_key_if_exists(key: String, collider: Node2D, delta: float):
	if _handlers.has(key):
		var handler = _handlers[key]
		handler.call(collider, delta)

func _create_event(type: String, collider: Node2D):
	return InteractionEvent.new(collider, type)