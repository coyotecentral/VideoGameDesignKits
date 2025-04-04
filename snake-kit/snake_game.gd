extends SnakeKit

var next_direction = Vector2i()
var food = SnakeKitTile.new()
var score = 0 
var ispaused = true

func _ready():
	super()
	food.position = Vector2i(OFFSET_X, OFFSET_X)
	food.tile_color = Color.BLUE
	add_child(food)
	move_food()
	
	$CanvasLayer.done.connect(func():
		ispaused = false
		$CanvasLayer.queue_free())

func random_position():
	var rand = Vector2i( randi_range(0, MAX_X),randi_range(0, MAX_Y))
	for segment in snake:
		if segment.tile_position == rand:
			return random_position()
	return rand
	
func move_food():
	var next_position = random_position()
	food.position = SnakeKit.TILE_SIZE * next_position + Vector2i(OFFSET_X, OFFSET_Y)

func tick ():
	if next_direction and next_direction + direction != Vector2i.ZERO:
		direction =next_direction
	var s = spawn_segment(snake[0].tile_position + direction)
	snake.push_front(s)
	if snake[0].pixel_position != food.pixel_position:
		remove_tail()
	else :
		move_food()
		score = score + 1000
	check_snake()
	score = score + 1
	$Control.score_label.text = "%d" % score

func _process(delta):
	timer.paused = ispaused
	if Input.is_action_just_pressed("up"):
		next_direction = Vector2i.UP
	if Input.is_action_just_pressed("left"):
		next_direction = Vector2i.LEFT
	if Input.is_action_just_pressed("down"):
		next_direction = Vector2i.DOWN
	if Input.is_action_just_pressed("right"):
		next_direction = Vector2i.RIGHT
	
func check_snake():
	var hp = snake[0].tile_position
	if hp.x < 0 or hp.y < 0 or hp.y > MAX_Y or hp.x > MAX_X:
		$lose.visible = true
		ispaused = true
	for i in range(1,snake.size()):
		if hp == snake[1].tile_position:
			$lose.visible = true
			ispaused = true
	
