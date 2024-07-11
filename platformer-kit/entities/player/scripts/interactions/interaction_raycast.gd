extends RayCast2D
class_name InteractionRaycast

signal movable_crate(collider: Node2D)
signal damage(collider: Node2D)
signal gem(collider: Node2D)
signal ladder(collider: Node2D)

func process_collision() -> InteractionEvent:
	var collider = get_collider()
	if collider:
		if collider is MovableCrate:
			movable_crate.emit(collider)
			return InteractionEvent.new(collider, InteractionTypes.PushableObject)
		if collider is Spike:
			damage.emit(collider)
			return InteractionEvent.new(collider, InteractionTypes.Damage)
		if collider is Gem:
			gem.emit(collider)
			return InteractionEvent.new(collider, InteractionTypes.Gem)
		if collider is StaticBody2D and collider.get_parent() is Ladder:
			ladder.emit(collider)
			return InteractionEvent.new(collider, InteractionTypes.Ladder)
		if collider is Area2D:
			var parent = collider.get_parent()
			if parent is Ladder:
				ladder.emit(collider)
				return InteractionEvent.new(collider, InteractionTypes.Ladder)
	return InteractionEvent.new(collider, InteractionTypes.NoOp)