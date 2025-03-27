extends Area2D

signal teleport(position: Vector2)


# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _process_physics(delta):
	pass

func _on_body_entered(node: Node2D):
	if node is Player:
		teleport.emit($Marker2D.position)
