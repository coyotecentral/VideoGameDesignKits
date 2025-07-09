extends Node

var _respawn_position := Vector2()
var _checkpoint_active := false
var _gem_count := 0
var _key_count := 0
var _death_count := 0
var _final_death_count := 0

var _scene_file_path: String = ""

var _entities_to_reset: Array[RespawnData] = []
var _total_gems := 0
var _seconds_elapsed := 0
var _final_time := 0
var _is_completed := false

func increment_score(amount: int = 1):
	_gem_count += amount

func increment_time(amount: int = 1):
	_seconds_elapsed += amount

func increment_key_count():
	_key_count += 1

func decrement_key_count():
	if _key_count > 0:
		_key_count -= 1

func get_seconds_elapsed():
	return _seconds_elapsed

func get_final_time():
	return _final_time

func increment_death_count(amount: int = 1):
	_death_count += amount

func get_final_death_count():
	return _final_death_count

func set_spawn_position(position: Vector2) -> void:
	_respawn_position = position

func get_spawn_position() -> Vector2:
	return _respawn_position

func get_gem_count():
	return _gem_count

func get_total_gem_count():
	return _total_gems

func get_death_count():
	return _death_count

func get_key_count():
	return _key_count

func has_checkpoint() -> bool:
	return _checkpoint_active

func set_checkpoint(position: Vector2) -> void:
	_checkpoint_active = true
	set_spawn_position(position)

func set_scene_path(path: String):
	_scene_file_path = path

func reset_level():
	get_tree().change_scene_to_file(_scene_file_path)

func respawn():
	if not _checkpoint_active:
		# TODO
		# Level will fully reset, gems included (for now)
		# _gem_count = 0
		# reset_level()
		return
	
func reset_entities():
	for meta in _entities_to_reset:
		var entity = meta.entity
		if is_instance_valid(entity):
			entity.global_position = meta.spawn_position
			entity.handle_reset()

# Expect entity to have a `reset()` method and an `initial_position` property
func register_entity_for_reset(entity: Node2D):
	_entities_to_reset.push_back(RespawnData.new(entity, entity.initial_position))

func register_gem(gem: Gem):
	_total_gems += 1

func is_gems_completed():
	return (_gem_count >= _total_gems) and _total_gems > 0

func complete_level():
	if not _is_completed:
		_final_time = _seconds_elapsed
		_final_death_count = _death_count
		_is_completed = true

func reset_variables():
	# Reset variables
	_is_completed = false
	_entities_to_reset.resize(0)
	_gem_count = 0
	_death_count = -1
	_checkpoint_active = false
	_respawn_position = Vector2()
	_total_gems = 0
	_seconds_elapsed = 0
