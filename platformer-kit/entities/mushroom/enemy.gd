extends CharacterBody2D
class_name EnemyBody2D

@export_group("Options")
@export var drops_key := false
@export var drops_gem := false
@export var move_speed := 100.0
@export var max_health = 1

var key_scene = preload("uid://7dk38e0dxucg")
var gem_scene = preload("uid://dturik0w3xp6k")
var dropped_items: Array[Node] = []

@export_group("Don't touch")
@export var state_machine: EnemyStateMachine
@export var animations: AnimationPlayer
@export var death_state: CharacterState
@export var respawnable := true

var initial_position: Vector2
var did_drop := false
var _current_health = 1

signal death
signal damage

func _ready() -> void:
	_current_health = max_health
	state_machine.init(self)
	death.connect(_on_death)
	initial_position = global_position
	LevelController.register_entity_for_reset(self)
	# Hack to make sure the gem counter is accurate
	if drops_gem:
		LevelController._total_gems += 1
	damage.connect(func():
		_take_damage(1)
	)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	if _current_health == max_health:
		$HealthBar.visible = false
	else:
		$HealthBar.visible = true
		var current_bar: ColorRect = $HealthBar.get_node("Current")
		current_bar.size.x = $HealthBar.size.x * _current_health / max_health


	if _current_health <= 0:
		$HealthBar.visible = false
		death.emit()

func _on_death():
	if not did_drop:
		if drops_key:
			var d: RigidBody2D = key_scene.instantiate()
			get_tree().get_root().add_child(d)
			d.position = global_position
			d.linear_velocity = Vector2(randi_range(-100, 100), randi_range(-100, 0))
			dropped_items.append(d)
		if drops_gem:
			var d: = gem_scene.instantiate()
			get_tree().get_root().add_child(d)
			d.position = global_position
			# Hack to make sure the gem counter is accurate
			dropped_items.append(d)
			LevelController._total_gems -= 1
		did_drop = true

	set_collision_layer_value(1, false)
	set_collision_layer_value(2, false)
	set_collision_mask_value(1, false)
	state_machine.change_state(death_state)

func _take_damage(amount: float) -> void:
	_current_health -= amount
	print(_current_health)

func handle_reset():
	set_collision_layer_value(1, true)
	set_collision_layer_value(2, true)
	set_collision_mask_value(1, true)
	animations.play("RESET")
	state_machine.change_state(state_machine.starting_state)
	visible = true
	velocity = Vector2()
	_current_health = max_health
	if did_drop:
		var decrement_gem = drops_gem
		if drops_key:
			LevelController.decrement_key_count()

		for d in dropped_items:
				if is_instance_valid(d):
					if d is Gem:
						decrement_gem = false
					d.queue_free()
		if decrement_gem:
			LevelController._gem_count -= 1

		did_drop = false