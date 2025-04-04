extends SnakeKit
var next_direction = Vector2i() 
var food = SnakeKitTile.new() 
var score = 0
var is_paused = true

func _ready() :
	super () 
	food.position = Vector2i(OFFSET_X, OFFSET_Y) 
	food.tile_color = Color.YELLOW 
	add_child(food) 
	$Canvaslayer.done.connect(func():
		is_paused = false
		$Canvaslayer.queue_free())
func move_food(): 
	var next_position = random_position()
	food.position = SnakeKit.TILE_SIZE * next_position + Vector2i(OFFSET_X, OFFSET_Y) 
	
func random_position(): 
	var result = Vector2i(\
	randi_range(0, MAX_X), \
	randi_range(0, MAX_Y)) 

	for serpent in snake: 
		if serpent.tile_position == result: 
			return random_position()
	
	return result

func tick():
	if next_direction and next_direction + direction != Vector2i.ZERO: 
		direction = next_direction
	var s = spawn_segment(snake[0].tile_position +direction)
	snake.push_front(s)
	if snake[0].pixel_position !=food.pixel_position:
		remove_tail() 
	else:
		move_food()
		score = score + 10
	$Control.score_label.text = "%d" % score
	check_snake()
func _process(delta):
	timer.paused = is_paused
	if Input. is_action_just_pressed("up"):
		next_direction = Vector2i.UP 
	if Input. is_action_just_pressed("left"):
		next_direction = Vector2i.LEFT
	if Input. is_action_just_pressed("right"):
		next_direction = Vector2i.RIGHT 
	if Input. is_action_just_pressed("down"):
		next_direction = Vector2i.DOWN 
func check_snake():	
	#hp = Head position
	var hp = snake[0].tile_position
	if hp.x < 0 or hp.y < 0 or hp.x > MAX_X or hp.y > MAX_Y:
		$LoseScreen.visible = true 
		is_paused = true
	for i in range(1, snake.size()): 
		if hp == snake[i].tile_position:
			$LoseScreen.visible = true
			is_paused = true
