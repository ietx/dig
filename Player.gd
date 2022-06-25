extends TileMap

var player_position = Vector2.ZERO
var player_depth = 0 
var direction = Vector2.ZERO
var sonar_array = []
var layer1_array = []

func _ready():
	
	
	
	player_position = Vector2(2,2)
	set_cell(player_position.x, player_position.y, 0)


	pass # Replace with function body.
func _process(delta):
	
	layer1_array = $Layer1.get_used_cells()
	
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

func move_player():
	set_cell(player_position.x, player_position.y, -1)
	player_position += direction
	set_cell(player_position.x, player_position.y, 0)
	direction = Vector2.ZERO
	
func sonar():
	sonar_array.append(get_cell(player_position.x - 1, player_position.y))
	sonar_array.append(get_cell(player_position.x + 1, player_position.y))
	sonar_array.append(get_cell(player_position.x - 1, player_position.y - 1))
	
func break_tile():
	if layer1_array.has(player_position):
		$Layer1.set_cell(player_position.x, player_position.y, -1)
	
