@tool
extends Node2D
class_name SnakeKitTile

# TODO support sprites

@export var tile_color: Color = Color.WHITE_SMOKE

func _draw() -> void:
	draw_rect(Rect2(Vector2(-SnakeKit.TILE_SIZE / 2, -SnakeKit.TILE_SIZE / 2), Vector2(SnakeKit.TILE_SIZE, SnakeKit.TILE_SIZE)), tile_color)

var tile_position: Vector2i:
	get:
		return Vector2i(floori((position.x - SnakeKit.OFFSET_X) / SnakeKit.TILE_SIZE), \
										floori((position.y - SnakeKit.OFFSET_Y) / SnakeKit.TILE_SIZE))

var pixel_position: Vector2:
	get:
		return position

func _process(delta: float) -> void:
	queue_redraw()