extends Node2D

const TILE_SCENE = preload("res://tile.tscn")

const GRID_SIZE = 4
const TILE_SIZE = 140

var status: Array[int] = []
var tiles: Array[Node] = []
var touch_start := Vector2.ZERO
var up_was_pressed := false
var score := 0
var game_over := false
@onready var score_label : Label = $ScoreLabel
@onready var game_over_label : Label = $GameOverLabel


func setup_list():
	status.clear()

	for i in range(GRID_SIZE * GRID_SIZE):
		status.append(0)


func can_move():
	for i in range(status.size()):
		if status[i] == 0:
			return true
		var x = i%GRID_SIZE
		var y = floori(float(i)/GRID_SIZE)
		
		if x < GRID_SIZE - 1  and status[i] ==status[i+1]:
			return true
		if y < GRID_SIZE -1 and status[i] == status[i+GRID_SIZE]:
			return true
	return false 


func update_tiles():
	for i in range(GRID_SIZE * GRID_SIZE):
		tiles[i].update_tile(status[i])
		
	score_label.text="Score: " +str(score)


func compress_line(i1: int, i2: int, i3: int, i4: int):
	var temp: Array[int] = [
		status[i1],
		status[i2],
		status[i3],
		status[i4]
	]

	temp = temp.filter(func(value): return value != 0)

	if temp.size() >= 2 and temp[0] == temp[1]:
		var merged_value = temp[0] + temp[1]
		score += merged_value
		temp[0] += temp[1]
		temp.remove_at(1)

	if temp.size() >= 3 and temp[1] == temp[2]:
		var merged_value = temp[1] + temp[2]
		score += merged_value
		temp[1] += temp[2]
		temp.remove_at(2)

	if temp.size() >= 4 and temp[2] == temp[3]:
		var merged_value = temp[2] + temp [3]
		score +=merged_value
		temp[2] += temp[3]
		temp.remove_at(3)

	while temp.size() < 4:
		temp.append(0)

	status[i1] = temp[0]
	status[i2] = temp[1]
	status[i3] = temp[2]
	status[i4] = temp[3]

	update_tiles()


func move_up():
	var old_status = status.duplicate()
	compress_line(0, 4, 8, 12)
	compress_line(1, 5, 9, 13)
	compress_line(2, 6, 10, 14)
	compress_line(3, 7, 11, 15)
	
	if board_changed(old_status):
		spawn_new_tile()
	
func move_down():
	var old_status = status.duplicate()
	compress_line(12,8,4,0)
	compress_line(13,9,5,1)
	compress_line(14,10,6,2)
	compress_line(15,11,7,3)
	if board_changed(old_status):
		spawn_new_tile()
	
func move_left():
	var old_status = status.duplicate()
	compress_line(0,1,2,3)
	compress_line(4,5,6,7)
	compress_line(8,9,10,11)
	compress_line(12,13,14,15)
	if board_changed(old_status):
		spawn_new_tile()
	
func move_right():
	var old_status = status.duplicate()
	compress_line(3,2,1,0)
	compress_line(7,6,5,4)
	compress_line(11,10,9,8)
	compress_line(15,14,13,12)
	if board_changed(old_status):
		
		spawn_new_tile()


func spawn():
	
	for i in range(2):
		var random_index = randi_range(0, status.size() - 1)

		while status[random_index] != 0:
			random_index = randi_range(0, status.size() - 1)

		status[random_index] = 2 if randi_range(0, 1) == 0 else 4

	update_tiles()

func spawn_new_tile():
	await get_tree().create_timer(0.1).timeout
	var empty_positions: Array[int] = []

	for i in range(status.size()):
		if status[i] == 0:
			empty_positions.append(i)

	if empty_positions.is_empty():
		if not can_move():
			print("Game Over Hehehe!")
		return

	var random_index = empty_positions[randi_range(0, empty_positions.size() - 1)]
	status[random_index] = 4 if randi_range(1, 10) == 1 else 2

	update_tiles()
	if not can_move():
		print("Game Over Hehehe!")
		show_gameOver()
	
	

func show_gameOver():
	game_over = true
	game_over_label.visible = true

func _ready():
	
	
	setup_list()

	for i in range(GRID_SIZE * GRID_SIZE):
		var tile = TILE_SCENE.instantiate()
		add_child(tile)
		tiles.append(tile)

		var x = i % GRID_SIZE
		var y = floori(float(i) / GRID_SIZE)

		tile.position = Vector2(x * TILE_SIZE, y * TILE_SIZE)

	spawn()

func board_changed(old_status:Array[int]) -> bool:
	return old_status != status

func _input(event):
	if game_over:
		return
	if event.is_action_pressed("ui_up"):
		move_up()
	if event.is_action_pressed("ui_down"):
		move_down()
	if event.is_action_pressed("ui_left"):
		move_left()
	if event.is_action_pressed("ui_right"):
		move_right()
	
	if event is InputEventScreenTouch:
		if event.pressed:
			touch_start = event.position
		else:
			var swipe = event.position - touch_start
			
			if swipe.length()< 50 :
				return
			if abs(swipe.x)>abs(swipe.y):
				if swipe.x > 0:
					move_right()
				else:
					move_left()
			
			else:
				if swipe.y  > 0 :
					move_down()
				else:
					move_up()
		
