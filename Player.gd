extends TileMap

var player_position = Vector2.ZERO
var direction = Vector2.ZERO

func _ready():
	player_position = Vector2(2,2)
	set_cell(player_position.x, player_position.y, 0)


	pass # Replace with function body.

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
	
