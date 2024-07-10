extends RayCast2D
class_name InteractionRaycast

func get_interaction_event() -> InteractionEvent:
	var collider = get_collider()
	if collider:
		if collider is MovableCrate:
			return InteractionEvent.new(collider, InteractionTypes.PushableObject)
		if collider is Spike:
			return InteractionEvent.new(collider, InteractionTypes.Damage)
		if collider is Gem:
			return InteractionEvent.new(collider, InteractionTypes.Gem)
		if collider is StaticBody2D and collider.get_parent() is Ladder:
			return InteractionEvent.new(collider, InteractionTypes.Ladder)
		if collider is Area2D:
			var parent = collider.get_parent()
			if parent is Ladder:
				return InteractionEvent.new(collider, InteractionTypes.Ladder)
	return InteractionEvent.new(collider, InteractionTypes.NoOp)