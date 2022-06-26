extends Node2D

var player_position = Vector2.ZERO
var player_depth = 0 
var direction = Vector2.ZERO
var aim_tile = Vector2.ZERO

var sonar_array = []
var layer1_array = []
var layer2_array = []
var layer3_array = []

var all_itens = []

var score = 0
var life = 3

onready var bomb_scene = preload("res://Bomb.tscn")
onready var ribs_scene = preload("res://Ribs.tscn")
onready var leg_scene = preload("res://Leg.tscn")
onready var arm_scene = preload("res://Arm.tscn")
onready var head_scene = preload("res://Head.tscn")
onready var claw_scene = preload("res://Claw.tscn")
onready var single_bone_scene = preload("res://Single_Bone.tscn")

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
	depth_layer_node = $Layer1
	tile_size = $PlayerLayer.get_cell_size()
	
	for i in 44:
		var b = bomb_scene.instance()
		add_child(b)
		all_itens.append(b)
	
	var rib = ribs_scene.instance()
	add_child(rib)
	var leg = leg_scene.instance()
	add_child(leg)
	var leg2 = leg_scene.instance()
	add_child(leg2)
	var arm = arm_scene.instance()
	add_child(arm)
	var arm2 = arm_scene.instance()
	add_child(arm2)
	var head = head_scene.instance()
	add_child(head)
	var claw = claw_scene.instance()
	add_child(claw)
	var claw2 = claw_scene.instance()
	add_child(claw2)
	var single_bone = single_bone_scene.instance()
	add_child(single_bone)
	var single_bone2 = single_bone_scene.instance()
	add_child(single_bone2)
	
	all_itens.append_array([rib, leg, leg2, arm, arm2, head, claw, claw2, single_bone, single_bone2])
#	print(all_itens.size())
	
		
	randomize_itens_in_matrix()
	
	player_position = Vector2(2,2)
	$PlayerLayer.set_cell(player_position.x, player_position.y, 0)
	
	
	show_layer1_itens()
	hide_layer2_itens()
	hide_layer3_itens()


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
	
#	if player_depth == 0:
#		depth_layer_node = $Layer1
#		$Layer1.set_visible(true)
#		$Layer2.set_visible(false)
#		$Layer3.set_visible(false)
#
#
#	elif player_depth == 1:
#		depth_layer_node = $Layer2
#		$Layer1.set_visible(false)
#		$Layer2.set_visible(true)
#		$Layer3.set_visible(false)
#
#
#		hide_layer1_itens()
#
#	if player_depth == 2:
#		depth_layer_node = $Layer3
#		$Layer1.set_visible(false)
#		$Layer2.set_visible(false)
#		$Layer3.set_visible(true)
#
	
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
		
#	print(player_depth)
	
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
		
		if player_depth == 0:
			depth_layer_node = $Layer1
			$Layer1.set_visible(true)
			$Layer2.set_visible(false)
			$Layer3.set_visible(false)
			
			show_layer1_itens()
			hide_layer2_itens()
			hide_layer3_itens()
			
		elif player_depth == 1:
			depth_layer_node = $Layer2
			$Layer1.set_visible(false)
			$Layer2.set_visible(true)
			$Layer3.set_visible(false)
			
			hide_layer1_itens()
			show_layer2_itens()
			hide_layer3_itens()
			
			
			
		if player_depth == 2:
			depth_layer_node = $Layer3
			$Layer1.set_visible(false)
			$Layer2.set_visible(false)
			$Layer3.set_visible(true)
			
			hide_layer1_itens()
			hide_layer2_itens()
			show_layer3_itens()
		
	
		
		
	
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
	update_sonar()
	itens_around()
	
func update_sonar():
	print(player_position)
	sonar_array.clear()
	sonar_array.append(player_position + Vector2(-1, -1))
	sonar_array.append(player_position + Vector2(0, -1))
	sonar_array.append(player_position + Vector2(1, -1))
	
	sonar_array.append(player_position + Vector2(-1, 0))
	sonar_array.append(player_position + Vector2(1, 0))
	
	sonar_array.append(player_position + Vector2(-1, 1))
	sonar_array.append(player_position + Vector2(0, 1))
	sonar_array.append(player_position + Vector2(1, 1))
	

	
	
	print(sonar_array)
	
func break_tile():
	if layer1_array.has(player_position) and player_depth == 0:
		$Layer1.set_cell(player_position.x, player_position.y, 1)
	if layer2_array.has(player_position) and player_depth == 1:
		$Layer2.set_cell(player_position.x, player_position.y, 1)
	if layer3_array.has(player_position) and player_depth == 2:
		$Layer3.set_cell(player_position.x, player_position.y, 1)
	


func _on_Drill_animation_finished():
	
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
		
		if player_depth == 0:
			depth_layer_node = $Layer1
			$Layer1.set_visible(true)
			$Layer2.set_visible(false)
			$Layer3.set_visible(false)
			show_layer1_itens()
			hide_layer2_itens()
			hide_layer3_itens()
			
		elif player_depth == 1:
			depth_layer_node = $Layer2
			$Layer1.set_visible(false)
			$Layer2.set_visible(true)
			$Layer3.set_visible(false)
			
			show_layer2_itens()
			hide_layer1_itens()
			hide_layer3_itens()
		if player_depth == 2:
			depth_layer_node = $Layer3
			$Layer1.set_visible(false)
			$Layer2.set_visible(false)
			$Layer3.set_visible(true)
			hide_layer1_itens()
			hide_layer2_itens()
			show_layer3_itens()
		pass
		

func _on_Drill_Hit_Area_area_entered(area):
	
	
	for i in itens_layer1:
		if i[1] == area:
			itens_layer1.erase(i)

	for i in itens_layer2:
		if i[1] == area:
			itens_layer2.erase(i)
			
	for i in itens_layer3:
		if i[1] == area:
			itens_layer3.erase(i)
	
	if area.is_in_group("bones"):
		score += 1
		print(score)
		area.queue_free()
	
	if area.is_in_group("bomb"):
		life -= 1
		print(life)

func choose(array):
	return array[randi() % array.size()]	

func randomize_itens_in_matrix():
	
	[0, 1, 2]
	
	itens_layer1.append_array(random_itens_in_quadrant([0, 1, 2], [0, 1, 2]))
	itens_layer1.append_array(random_itens_in_quadrant([0, 1, 2], [3, 4, 5]))
	itens_layer1.append_array(random_itens_in_quadrant([0, 1, 2], [6, 7, 8]))
	itens_layer1.append_array(random_itens_in_quadrant([3, 4, 5], [0, 1, 2]))
	itens_layer1.append_array(random_itens_in_quadrant([3, 4, 5], [3, 4, 5]))
	itens_layer1.append_array(random_itens_in_quadrant([3, 4, 5], [6, 7, 8]))
	itens_layer1.append_array(random_itens_in_quadrant([6, 7, 8], [0, 1, 2]))
	itens_layer1.append_array(random_itens_in_quadrant([6, 7, 8], [3, 4, 5]))
	itens_layer1.append_array(random_itens_in_quadrant([6, 7, 8], [6, 7, 8]))
	
	itens_layer2.append_array(random_itens_in_quadrant([0, 1, 2], [0, 1, 2]))
	itens_layer2.append_array(random_itens_in_quadrant([0, 1, 2], [3, 4, 5]))
	itens_layer2.append_array(random_itens_in_quadrant([0, 1, 2], [6, 7, 8]))
	itens_layer2.append_array(random_itens_in_quadrant([3, 4, 5], [0, 1, 2]))
	itens_layer2.append_array(random_itens_in_quadrant([3, 4, 5], [3, 4, 5]))
	itens_layer2.append_array(random_itens_in_quadrant([3, 4, 5], [6, 7, 8]))
	itens_layer2.append_array(random_itens_in_quadrant([6, 7, 8], [0, 1, 2]))
	itens_layer2.append_array(random_itens_in_quadrant([6, 7, 8], [3, 4, 5]))
	itens_layer2.append_array(random_itens_in_quadrant([6, 7, 8], [6, 7, 8]))
	
	itens_layer3.append_array(random_itens_in_quadrant([0, 1, 2], [0, 1, 2]))
	itens_layer3.append_array(random_itens_in_quadrant([0, 1, 2], [3, 4, 5]))
	itens_layer3.append_array(random_itens_in_quadrant([0, 1, 2], [6, 7, 8]))
	itens_layer3.append_array(random_itens_in_quadrant([3, 4, 5], [0, 1, 2]))
	itens_layer3.append_array(random_itens_in_quadrant([3, 4, 5], [3, 4, 5]))
	itens_layer3.append_array(random_itens_in_quadrant([3, 4, 5], [6, 7, 8]))
	itens_layer3.append_array(random_itens_in_quadrant([6, 7, 8], [0, 1, 2]))
	itens_layer3.append_array(random_itens_in_quadrant([6, 7, 8], [3, 4, 5]))
	itens_layer3.append_array(random_itens_in_quadrant([6, 7, 8], [6, 7, 8]))
	
	
#	print(itens_layer1)
	
		

func random_itens_in_quadrant(arrayx,arrayy):
	
	var Q1 = []
	
	
	
	
	randomize()
	var Q1_choose_position
	Q1_choose_position = Vector2(choose(arrayx), choose(arrayy))
	while Q1_choose_position == Vector2(2,2):
		Q1_choose_position = Vector2(choose(arrayx), choose(arrayy))
	
	var object = choose(all_itens)
	all_itens.erase(object)
	
	object.position.x = Q1_choose_position.x * tile_size.x + tile_size.x/2
	object.position.y = Q1_choose_position.y * tile_size.y + tile_size.y/2
#	print(object.get_global_position())
#	print(all_itens.size())
#	print(object)
	
	

	randomize()
	var last_Q1_choose_position = Vector2()
	last_Q1_choose_position = Vector2(choose(arrayx), choose(arrayy))
	while Q1_choose_position == last_Q1_choose_position or last_Q1_choose_position == Vector2(2,2):
		randomize()
		last_Q1_choose_position = Vector2(choose(arrayx), choose(arrayy))
	var last_object = choose(all_itens)
	all_itens.erase(last_object)
	if last_Q1_choose_position == Vector2(0, 0):
		last_object.position = tile_size/Vector2(2,2)
	else:
		last_object.position = last_Q1_choose_position * tile_size + tile_size/ Vector2(2,2)
#	print(all_itens.size())
#	print(last_object)
	
	Q1.append([Q1_choose_position, object])
	Q1.append([last_Q1_choose_position, last_object])
#	print(Q1)
	
	return Q1

func hide_layer1_itens():
#	print (itens_layer1.size())
	for i in itens_layer1:
	
		i[1].position = Vector2(500,500)

func hide_layer2_itens():
#	print (itens_layer2.size())
	for i in itens_layer2:
		
		i[1].position = Vector2(500,500)

func hide_layer3_itens():
#	print (itens_layer3.size())
	for i in itens_layer3:
		
		i[1].position = Vector2(500,500)

func show_layer1_itens():
	print(get_tree())
	print (itens_layer1.size())
	for i in itens_layer1:
		print(i)
		i[1].position = i[0] * tile_size + tile_size/Vector2(2,2)

func show_layer2_itens():
	print (itens_layer2.size())
	for i in itens_layer2:
		print(i)
		i[1].position = i[0] * tile_size + tile_size/Vector2(2,2)

func show_layer3_itens():
	print (itens_layer3.size())
	for i in itens_layer3:
		print(i)
		i[1].position = i[0] * tile_size + tile_size/Vector2(2,2)
		
func itens_around():
	if player_depth == 0:
		for i in sonar_array:
			for j in itens_layer1:
				if i == j[0]:
					print("hey")
