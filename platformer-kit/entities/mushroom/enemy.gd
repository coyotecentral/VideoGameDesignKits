extends CharacterBody2D
class_name EnemyBody2D

@export var drops_key := false
var key_scene = preload("uid://7dk38e0dxucg")
var dropped_items: Array[Node] = []

@export var state_machine: EnemyStateMachine
@export var animations: AnimationPlayer
@export var death_state: CharacterState
@export var respawnable := true

var initial_position: Vector2
var did_drop := false
@export var max_health = 1
var _current_health = 1

signal death
signal damage

func _ready() -> void:
	_current_health = max_health
	state_machine.init(self)
	death.connect(_on_death)
	initial_position = global_position
	LevelController.register_entity_for_reset(self)
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
	if drops_key and not did_drop:
			var d: RigidBody2D = key_scene.instantiate()
			get_tree().get_root().add_child(d)
			d.position = global_position
			d.linear_velocity = Vector2(randi_range(-100, 100), randi_range(-100, 0))
			did_drop = true
			dropped_items.append(d)

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
	did_drop = false
	if drops_key:
		LevelController.decrement_key_count()
		did_drop = false
		for d in dropped_items:
			if is_instance_valid(d):
				d.queue_free()