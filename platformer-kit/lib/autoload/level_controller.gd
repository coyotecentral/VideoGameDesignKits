extends Node

var _respawn_position := Vector2()
var _checkpoint_active := false
var _gem_count := 0
var _death_count := -1
var _final_death_count := 0

var _scene_file_path: String = ""

var _enemies_to_respawn: Array[RespawnData] = []
var _total_gems := 0
var _seconds_elapsed := 0
var _final_time := 0
var _is_completed := false

func increment_score(amount: int = 1):
	_gem_count += amount

func increment_time(amount: int = 1):
	_seconds_elapsed += amount

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
	
func respawn_enemies():
	for e in _enemies_to_respawn:
		var root = get_tree().get_root()
		var scene = load(e.scene_file_path)
		var instance = scene.instantiate()
		root.add_child(instance)
		instance.initial_position = e.spawn_position
		instance.global_position = e.spawn_position
	_enemies_to_respawn = []

func register_enemy_for_respawn(enemy: EnemyBody2D):
	_enemies_to_respawn.push_back(RespawnData.new(enemy.scene_file_path, enemy.initial_position))

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
	_enemies_to_respawn = []
	_gem_count = 0
	_death_count = -1
	_checkpoint_active = false
	_respawn_position = Vector2()
	_total_gems = 0
	_seconds_elapsed = 0
