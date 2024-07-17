extends CharacterState

@export var screen_notifier: VisibleOnScreenNotifier2D

func enter() -> void:
	super()
	parent.velocity = Vector2.UP * 200

func process_physics(delta: float) -> State:
	parent.move_and_slide()
	parent.velocity += Vector2.DOWN * 100
	if not screen_notifier.is_on_screen():
		parent.visible = false
	return null