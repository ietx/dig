extends Node2D

var player_position = Vector2.ZERO
var player_depth = 0 
var direction = Vector2.ZERO
var aim_tile = Vector2.ZERO

var sonar_array = []
var layer1_array = []
var layer2_array = []
var layer3_array = []


var itens_layer1 = []
var itens_layer2 = []
var itens_layer3 = []
var bombs_number = 12
#player tile center

var tile_size = Vector2.ZERO
var player_tile_center = Vector2.ZERO

var first_movement_click = "right"

var aim_tile_center = Vector2.ZERO

var depth_layer_node
const MAX_LAYER_UP = 0
const MAX_LAYER_DOWN = 2

func _ready():
	tile_size = $PlayerLayer.get_cell_size()
	
	
	
	player_position = Vector2(2,2)
	$PlayerLayer.set_cell(player_position.x, player_position.y, 0)


	pass # Replace with function body.
func _process(delta):
	player_tile_center = Vector2((player_position.x * tile_size.x) + tile_size.x/2, (player_position.y * tile_size.y) + tile_size.y/2)
	$Drill.position = player_tile_center

	aim_tile_center = Vector2((aim_tile.x * tile_size.x) + tile_size.x/2, (aim_tile.y * tile_size.y) + tile_size.y/2)
	$Tile_Crack.position = aim_tile_center
#	print(first_movement_click)
	layer1_array = $Layer1.get_used_cells()
	layer2_array = $Layer2.get_used_cells()
	layer3_array = $Layer3.get_used_cells()
	
	if player_depth == 0:
		depth_layer_node = $Layer1
		$Layer1.set_visible(true)
		$Layer2.set_visible(false)
		$Layer3.set_visible(false)
	elif player_depth == 1:
		depth_layer_node = $Layer2
		$Layer1.set_visible(false)
		$Layer2.set_visible(true)
		$Layer3.set_visible(false)
	if player_depth == 2:
		depth_layer_node = $Layer3
		$Layer1.set_visible(false)
		$Layer2.set_visible(false)
		$Layer3.set_visible(true)
	
	break_tile()
	
	if first_movement_click == "up":
		$Drill.rotation_degrees = 270
		$Tile_Crack.rotation_degrees = 270
		aim_tile = Vector2(player_position.x, player_position.y - 1)
		$Aim.clear()
		$Aim.set_cell(aim_tile.x, aim_tile.y, 0)
		
	if first_movement_click == "left":
		$Drill.rotation_degrees = 180
		$Tile_Crack.rotation_degrees = 180
		aim_tile = Vector2(player_position.x - 1, player_position.y)
		$Aim.clear()
		$Aim.set_cell(aim_tile.x, aim_tile.y, 0)
		
	if first_movement_click == "down":
		$Drill.rotation_degrees = 90
		$Tile_Crack.rotation_degrees = 90
		aim_tile = Vector2(player_position.x, player_position.y + 1)
		$Aim.clear()
		$Aim.set_cell(aim_tile.x, aim_tile.y, 0)
		
	if first_movement_click == "right":
		$Drill.rotation_degrees = 0
		$Tile_Crack.rotation_degrees = 0
		aim_tile = Vector2(player_position.x + 1, player_position.y)
		$Aim.clear()
		$Aim.set_cell(aim_tile.x, aim_tile.y, 0)
		
	print(player_depth)
	
func _input(event):
	
	
	if Input.is_action_just_pressed("left") and first_movement_click == "left":
		if depth_layer_node.get_cell(aim_tile.x, aim_tile.y) == 0:
			$Drill.play("Drill")
			if player_depth == 0:
				$Tile_Crack.play("Crack1")
			elif player_depth == 1:
				$Tile_Crack.play("Crack2")
			elif player_depth == 2:
				$Tile_Crack.play("Crack3")
			direction = Vector2(-1,0)
		elif depth_layer_node.get_cell(aim_tile.x, aim_tile.y) == 1:
			direction = Vector2(-1,0)
			move_player()
		
	if Input.is_action_just_pressed("right") and first_movement_click == "right":
		if depth_layer_node.get_cell(aim_tile.x, aim_tile.y) == 0:
			$Drill.play("Drill")
			if player_depth == 0:
				$Tile_Crack.play("Crack1")
			elif player_depth == 1:
				$Tile_Crack.play("Crack2")
			elif player_depth == 2:
				$Tile_Crack.play("Crack3")
			direction = Vector2(1,0)
		elif depth_layer_node.get_cell(aim_tile.x, aim_tile.y) == 1:
			direction = Vector2(1,0)
			move_player()

	if Input.is_action_just_pressed("up") and first_movement_click == "up":
		if depth_layer_node.get_cell(aim_tile.x, aim_tile.y) == 0:
			$Drill.play("Drill")
			if player_depth == 0:
				$Tile_Crack.play("Crack1")
			elif player_depth == 1:
				$Tile_Crack.play("Crack2")
			elif player_depth == 2:
				$Tile_Crack.play("Crack3")
			direction = Vector2(0, -1)
		elif depth_layer_node.get_cell(aim_tile.x, aim_tile.y) == 1:
			direction = Vector2(0, -1)
			move_player()
			
	if Input.is_action_just_pressed("down") and first_movement_click == "down":
		if depth_layer_node.get_cell(aim_tile.x, aim_tile.y) == 0:
			$Drill.play("Drill")
			if player_depth == 0:
				$Tile_Crack.play("Crack1")
			elif player_depth == 1:
				$Tile_Crack.play("Crack2")
			elif player_depth == 2:
				$Tile_Crack.play("Crack3")
			direction = Vector2(0, 1)
		elif depth_layer_node.get_cell(aim_tile.x, aim_tile.y) == 1:
			direction = Vector2(0, 1)
			move_player()

	if Input.is_action_just_pressed("dive_up"):
		$Drill.play("Drill_Up")
#		player_depth += 1
	if Input.is_action_just_pressed("dive_down"):
		$Drill.play("Drill_Down")
		player_depth -= 1
		
		
	
	#aim the next drill 
	
	if Input.is_action_just_pressed("left"):
		first_movement_click = "left"
	if Input.is_action_just_pressed("right"):
		first_movement_click = "right"
	if Input.is_action_just_pressed("up"):
		first_movement_click = "up"
	if Input.is_action_just_pressed("down"):
		first_movement_click = "down"

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
	if layer1_array.has(player_position) and player_depth == 0:
		$Layer1.set_cell(player_position.x, player_position.y, 1)
	if layer2_array.has(player_position) and player_depth == 1:
		$Layer2.set_cell(player_position.x, player_position.y, 1)
	if layer3_array.has(player_position) and player_depth == 2:
		$Layer3.set_cell(player_position.x, player_position.y, 1)
	


func _on_Drill_animation_finished():
	print($Drill.get_animation())
	if $Drill.get_animation() == "Drill":
		move_player()
		$Drill.stop()
		$Drill.set_frame(0)
		$Tile_Crack.stop()
		$Tile_Crack.set_frame(0)
	
	if $Drill.get_animation() == "Drill_Down":
		$Drill.play("Drill")
		$Drill.set_frame(0)
		$Drill.stop()
		
	if $Drill.get_animation() == "Drill_Up":
		$Drill.play("Drill")
		$Drill.set_frame(0)
		$Drill.stop()
		player_depth += 1
		pass
		

#func _on_Drill_Hit_Area_area_entered(area):
#	print("Hey")
