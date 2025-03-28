# SnakeKit maintains 2 coordinate systems:
#
# - Pixel Position: (aka world position) This is the actual
#			coordinates of the object's origin as rendered on screen
# - Tile Position: this is the position of an object as mapped
#			to a grid-based coordinate system a la tiles
#
# Just as with the native TileMap and TileMapLayer nodes, you
# can switch between these coordinates using the convenience
# methods `get_tile_position` and `get_pixel_position`

extends Node
class_name SnakeKit

# An array of SnakeSegments
var snake: Array[SnakeSegment] = []
var direction: Vector2i = Vector2i.UP

var timer: Timer

@export var tick_rate: float = 2.0

# Values determined from screen size of 640x360 with tile size 16px
const TILE_SIZE = 16
const OFFSET_X = 24
const OFFSET_Y = 48
const MAX_Y = 18
const MAX_X = 37


func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = 1.0 / tick_rate
	timer.timeout.connect(tick)
	add_child(timer)
	timer.start()

	_init_snake()

func _init_snake():
	for i in range(0, 3):
		var segment = spawn_segment(Vector2i(MAX_X / 2, MAX_Y / 2) + Vector2i.DOWN * i)
		snake.push_back(segment)

func spawn_segment(position: Vector2i) -> SnakeSegment:
	var segment = SnakeSegment.new()
	segment.position = Vector2(position.x * TILE_SIZE + OFFSET_X, position.y * TILE_SIZE + OFFSET_Y)
	add_child(segment)
	return segment

# Returns the tile position from the given screen coordinates
func get_tile_position(pixel_position: Vector2) -> Vector2i:
	return Vector2i(floori((pixel_position.x - SnakeKit.OFFSET_X) / TILE_SIZE), \
									floori((pixel_position.y - SnakeKit.OFFSET_Y) / TILE_SIZE))

# Returns the screen position from the given tile coordinates
func get_pixel_position(tile_position) -> Vector2:
	return Vector2(tile_position.x * TILE_SIZE + OFFSET_X, tile_position.y * TILE_SIZE + OFFSET_Y)

func remove_tail():
	snake.pop_back().queue_free()

func set_tick_rate(value: float):
	tick_rate = value

# Abstract function to be implemented by students
func tick() -> void:
	pass