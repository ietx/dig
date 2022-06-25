extends Node2D

var player_position = Vector2.ZERO
var player_depth = 0 
var direction = Vector2.ZERO
var sonar_array = []
var layer1_array = []
var layer2_array = []

const MAX_LAYER_UP = 0
const MAX_LAYER_DOWN = 2

func _ready():
	
	
	
	player_position = Vector2(2,2)
	$PlayerLayer.set_cell(player_position.x, player_position.y, 0)


	pass # Replace with function body.
func _process(delta):
	print(player_depth)
	layer1_array = $Layer1.get_used_cells()
	layer2_array = $Layer2.get_used_cells()
	
	break_tile()
	
func _input(event):
	
	if Input.is_action_just_pressed("left"):
		direction = Vector2(-1,0)
		move_player()
	if Input.is_action_just_pressed("right"):
		direction = Vector2(1,0)
		move_player()
	if Input.is_action_just_pressed("up"):
		direction = Vector2(0,-1)
		move_player()
	if Input.is_action_just_pressed("down"):
		direction = Vector2(0,1)
		move_player()
	if Input.is_action_just_pressed("dive_up"):
		player_depth += 1
	if Input.is_action_just_pressed("dive_down"):
		player_depth -= 1

func move_player():
	$PlayerLayer.set_cell(player_position.x, player_position.y, -1)
	player_position += direction
	$PlayerLayer.set_cell(player_position.x, player_position.y, 0)
	direction = Vector2.ZERO
	
func sonar():
	sonar_array.append($PlayerLayer.get_cell(player_position.x - 1, player_position.y))
	sonar_array.append($PlayerLayer.get_cell(player_position.x + 1, player_position.y))
	sonar_array.append($PlayerLayer.get_cell(player_position.x - 1, player_position.y - 1))
	
func break_tile():
	if layer1_array.has(player_position) and player_depth == 1:
		$Layer1.set_cell(player_position.x, player_position.y, 1)
	if layer2_array.has(player_position) and player_depth == 2:
		$Layer2.set_cell(player_position.x, player_position.y, -1)
	
