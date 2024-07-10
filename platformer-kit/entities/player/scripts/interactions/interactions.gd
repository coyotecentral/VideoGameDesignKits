class_name InteractionHandlers

static func push_object(force: Vector2, event: InteractionEvent, delta: float) -> void:
	var colliding_object := event.get_collider()
	colliding_object.position += force * delta

static func take_damage(player: Player, amount: int = 1) -> void:
	player.damage_taken.emit(amount)