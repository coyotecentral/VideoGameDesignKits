extends RayCast2D
class_name InteractionRaycast

var _handlers: Dictionary = {}

func set_handler(name: String, handler: Callable) -> void:
	_handlers[name] = handler

# Sets the same handler for different interaction types
func set_handlers(names: Array, handler: Callable) -> void:
	for n in names:
		_handlers[n] = handler

func remove_handler(name: String) -> void:
	_handlers.erase(name)

func process_collision(delta: float) -> InteractionEvent:
	var collider = get_collider()
	var create_event = _create_event.bind(collider)
	if collider is Area2D:
		collider = collider.get_parent()
	var event = _process_collision(collider)
	if event:
		_call_handler_for_event(event, delta)
	return event

func _process_collision(collider: Node2D) -> InteractionEvent:
	var create_event = _create_event.bind(collider)
	var event: InteractionEvent
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
	if collider is Ladder:
		event = create_event.call(InteractionTypes.Ladder)
	if collider is BounceShroom:
		event = create_event.call(InteractionTypes.BounceShroom)
	return event

func _call_handler_for_event(event: InteractionEvent, delta: float):
	var type = event.get_interaction_type()
	if _handlers.has(type):
		var handler = _handlers[type]
		handler.call(event.get_collider(), delta)


func _create_event(type: String, collider: Node2D):
	return InteractionEvent.new(collider, type)