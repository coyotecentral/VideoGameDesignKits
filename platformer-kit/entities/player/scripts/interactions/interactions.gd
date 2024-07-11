class_name InteractionHandlers

static func push_object(collider: Node2D, force: Vector2, delta: float) -> void:
	collider.position += force * delta

static func take_damage(player: Player, amount: int=1) -> void:
	player.damage_taken.emit(amount)

static func collect_gem(player: Player, gem: Gem) -> void:
	if not gem.is_collected:
		gem.collect()
		player.gem_collected.emit()