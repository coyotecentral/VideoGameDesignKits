extends RayCast2D
class_name InteractionRaycast

func get_interaction_event() -> InteractionEvent:
	var collider = get_collider()
	if collider:
		if collider is MovableCrate:
			return InteractionEvent.new(collider, InteractionTypes.PushableObject)
		if collider is Spike:
			return InteractionEvent.new(collider, InteractionTypes.Damage)
	return InteractionEvent.new(collider, InteractionTypes.NoOp)