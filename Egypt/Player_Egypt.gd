extends Node2D

var cursor_you_loose = 0 

var can_move = true

var end_game = "No_End" 
var player_position = Vector2.ZERO
var player_depth = 0 
var direction = Vector2.ZERO
var aim_tile = Vector2.ZERO

var sonar_array = []
var bombs_in_sonar_range = 0
var bones_in_sonar_range = 0

var current_tool = "Drill"
var pica_using_times = 10


var layer1_array = []
var layer2_array = []
var layer3_array = []
var layer4_array = []
var layer5_array = []

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
var itens_layer4 = []
var itens_layer5 = []

#player tile center

var tile_size = Vector2.ZERO
var player_tile_center = Vector2.ZERO

var first_movement_click = "right"


var aim_tile_center = Vector2.ZERO

var depth_layer_node
const MAX_LAYER_UP = 0
const MAX_LAYER_DOWN = 4

func _ready():

	$HUD/Itens.text = String(score)
	$HUD/Lifes.text = String(life)
	
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
	
	player_position = Vector2(4,4)
	$PlayerLayer.set_cell(player_position.x, player_position.y, 0)
	
	
	show_layer1_itens()
	hide_layer2_itens()
	hide_layer3_itens()
	hide_layer4_itens()
	hide_layer5_itens()
	update_sonar()
	itens_around()


	pass # Replace with function body.
func _process(delta):
#	print($Layer5.get_cellv(player_position))
#	print(player_position)

	
	#HUD LAYERS
	if player_depth == 0:
		$HUD/Floors.play("Floor1")
	if player_depth == 1:
		$HUD/Floors.play("Floor2")
	if player_depth == 2:
		$HUD/Floors.play("Floor3")
		
	if pica_using_times <= 0:
		
			current_tool = "Drill"
				
	$HUD/Pica_Remains.text = String(pica_using_times)
	
	
	if score >= 10:
		you_win()
	
	#UPDATE PLAYER POSITION
	player_tile_center = Vector2((player_position.x * tile_size.x) + tile_size.x/2, (player_position.y * tile_size.y) + tile_size.y/2)
	$Drill.position = player_tile_center

	#UPDATE AIM POSITION
	aim_tile_center = Vector2((aim_tile.x * tile_size.x) + tile_size.x/2, (aim_tile.y * tile_size.y) + tile_size.y/2)
	$Tile_Crack.position = aim_tile_center
#	print(first_movement_click)

	layer1_array = $Layer1.get_used_cells()
	layer2_array = $Layer2.get_used_cells()
	layer3_array = $Layer3.get_used_cells()
	layer4_array = $Layer4.get_used_cells()
	layer5_array = $Layer5.get_used_cells()
	

	
	break_tile()
	
	$Pica.position = aim_tile * tile_size + tile_size/Vector2(2,2)
	
	
	
	if current_tool == "Pica":
		$Pica.set_visible(true)
		$HUD/Tool.play("Pica")
	elif current_tool == "Drill":
		$Pica.set_visible(false)
		$HUD/Tool.play("Drill")
	
	#AIM THE TOOL / FIRST CLICK
	if first_movement_click == "up":
		$Drill.rotation_degrees = 270
		$Tile_Crack.rotation_degrees = 270
		aim_tile = Vector2(player_position.x, player_position.y - 1)
		$Aim.clear()
		if current_tool == "Pica":
			$Aim.set_cell(aim_tile.x, aim_tile.y, 0)
		elif current_tool == "Drill":
			$Aim.set_cell(aim_tile.x, aim_tile.y, 1)
		
	if first_movement_click == "left":
		$Drill.rotation_degrees = 180
		$Tile_Crack.rotation_degrees = 180
		aim_tile = Vector2(player_position.x - 1, player_position.y)
		$Aim.clear()
		if current_tool == "Pica":
			$Aim.set_cell(aim_tile.x, aim_tile.y, 0)
		elif current_tool == "Drill":
			$Aim.set_cell(aim_tile.x, aim_tile.y, 1)
		
	if first_movement_click == "down":
		$Drill.rotation_degrees = 90
		$Tile_Crack.rotation_degrees = 90
		aim_tile = Vector2(player_position.x, player_position.y + 1)
		$Aim.clear()
		if current_tool == "Pica":
			$Aim.set_cell(aim_tile.x, aim_tile.y, 0)
		elif current_tool == "Drill":
			$Aim.set_cell(aim_tile.x, aim_tile.y, 1)
		
	if first_movement_click == "right":
		$Drill.rotation_degrees = 0
		$Tile_Crack.rotation_degrees = 0
		aim_tile = Vector2(player_position.x + 1, player_position.y)
		$Aim.clear()
		if current_tool == "Pica":
			$Aim.set_cell(aim_tile.x, aim_tile.y, 0)
		elif current_tool == "Drill":
			$Aim.set_cell(aim_tile.x, aim_tile.y, 1)
		
#	print(player_depth)

func _input(event):
	
	#ACTUALY MOVE
	if can_move == true and end_game == "No_End":
		if Input.is_action_just_pressed("left") and first_movement_click == "left":
			
			can_move = false
			
			if player_depth == 0:
				for i in itens_layer1:
					if aim_tile == i[0]:
						i[1].set_visible(true)
			elif player_depth == 1:
				for i in itens_layer2:
					if aim_tile == i[0]:
						i[1].set_visible(true)
			elif player_depth == 2:
				for i in itens_layer3:
					if aim_tile == i[0]:
						i[1].set_visible(true)
				
			
			if depth_layer_node.get_cell(aim_tile.x, aim_tile.y) == 0:
				if current_tool == "Drill":
					$FX/Drill.play()
				elif current_tool == "Pica":
					$FX/Pica.play()
				$Drill.play("Drill")
				if player_depth == 0:
					$Tile_Crack.play("Crack1")
				elif player_depth == 1:
					$Tile_Crack.play("Crack2")
				elif player_depth == 2:
					$Tile_Crack.play("Crack3")
				direction = Vector2(-1,0)
			elif depth_layer_node.get_cell(aim_tile.x, aim_tile.y) == 1:
				$FX/DriveAround.play()
				direction = Vector2(-1,0)
				move_player()
			
			elif depth_layer_node.get_cell(aim_tile.x, aim_tile.y) == -1 or depth_layer_node.get_cell(aim_tile.x, aim_tile.y) == 2:
				can_move = true
				$FX/Not_Available.play()
			
		if Input.is_action_just_pressed("right") and first_movement_click == "right":
			
			can_move = false
			
			if player_depth == 0:
				for i in itens_layer1:
					if aim_tile == i[0]:
						i[1].set_visible(true)
			elif player_depth == 1:
				for i in itens_layer2:
					if aim_tile == i[0]:
						i[1].set_visible(true)
			elif player_depth == 2:
				for i in itens_layer3:
					if aim_tile == i[0]:
						i[1].set_visible(true)
			
			if depth_layer_node.get_cell(aim_tile.x, aim_tile.y) == 0:
				if current_tool == "Drill":
					$FX/Drill.play()
				elif current_tool == "Pica":
					$FX/Pica.play()
					
				$Drill.play("Drill")
				if player_depth == 0:
					$Tile_Crack.play("Crack1")
				elif player_depth == 1:
					$Tile_Crack.play("Crack2")
				elif player_depth == 2:
					$Tile_Crack.play("Crack3")
				direction = Vector2(1,0)
			elif depth_layer_node.get_cell(aim_tile.x, aim_tile.y) == 1:
				$FX/DriveAround.play()
				direction = Vector2(1,0)
				move_player()
			
			elif depth_layer_node.get_cell(aim_tile.x, aim_tile.y) == -1 or depth_layer_node.get_cell(aim_tile.x, aim_tile.y) == 2:
				can_move = true
				$FX/Not_Available.play()

		if Input.is_action_just_pressed("up") and first_movement_click == "up":
		
			can_move = false
			if player_depth == 0:
				for i in itens_layer1:
					if aim_tile == i[0]:
						i[1].set_visible(true)
			elif player_depth == 1:
				for i in itens_layer2:
					if aim_tile == i[0]:
						i[1].set_visible(true)
			elif player_depth == 2:
				for i in itens_layer3:
					if aim_tile == i[0]:
						i[1].set_visible(true)
			
			if depth_layer_node.get_cell(aim_tile.x, aim_tile.y) == 0:
				
				if current_tool == "Drill":
					$FX/Drill.play()
				elif current_tool == "Pica":
					$FX/Pica.play()
				
				$Drill.play("Drill")
				if player_depth == 0:
					$Tile_Crack.play("Crack1")
				elif player_depth == 1:
					$Tile_Crack.play("Crack2")
				elif player_depth == 2:
					$Tile_Crack.play("Crack3")
				direction = Vector2(0, -1)
			elif depth_layer_node.get_cell(aim_tile.x, aim_tile.y) == 1:
				$FX/DriveAround.play()
				direction = Vector2(0, -1)
				move_player()
			elif depth_layer_node.get_cell(aim_tile.x, aim_tile.y) == -1 or depth_layer_node.get_cell(aim_tile.x, aim_tile.y) == 2:
				can_move = true
				$FX/Not_Available.play()
				
				
		if Input.is_action_just_pressed("down") and first_movement_click == "down":
			
			can_move = false
			
			if player_depth == 0:
				for i in itens_layer1:
					if aim_tile == i[0]:
						i[1].set_visible(true)
			elif player_depth == 1:
				for i in itens_layer2:
					if aim_tile == i[0]:
						i[1].set_visible(true)
			elif player_depth == 2:
				for i in itens_layer3:
					if aim_tile == i[0]:
						i[1].set_visible(true)
			
			if depth_layer_node.get_cell(aim_tile.x, aim_tile.y) == 0:
				
				if current_tool == "Drill":
					$FX/Drill.play()
				elif current_tool == "Pica":
					$FX/Pica.play()
				
				$Drill.play("Drill")
				if player_depth == 0:
					$Tile_Crack.play("Crack1")
				elif player_depth == 1:
					$Tile_Crack.play("Crack2")
				elif player_depth == 2:
					$Tile_Crack.play("Crack3")
				direction = Vector2(0, 1)
			elif depth_layer_node.get_cell(aim_tile.x, aim_tile.y) == 1:
				$FX/DriveAround.play()
				direction = Vector2(0, 1)
				move_player()
			elif depth_layer_node.get_cell(aim_tile.x, aim_tile.y) == -1 or depth_layer_node.get_cell(aim_tile.x, aim_tile.y) == 2:
				can_move = true
				$FX/Not_Available.play()
				
				
		
		#PLAYING DRILL UO AND DOWN ANIMATION
		if Input.is_action_just_pressed("dive_down")and player_depth <= 4:
			
			if player_depth == 0:
				if $Layer2.get_cellv(player_position) == 2:
					$FX/Not_Available.play()
				else:
					$FX/DiveUp.play()
					can_move = false
					$Drill.play("Drill_Up")
			
			if player_depth == 1:
				if $Layer3.get_cellv(player_position) == 2:
					$FX/Not_Available.play()
				else:
					$FX/DiveUp.play()
					can_move = false
					$Drill.play("Drill_Up")
					
			if player_depth == 2:
				if $Layer4.get_cellv(player_position) == 2:
					$FX/Not_Available.play()
				else:
					$FX/DiveUp.play()
					can_move = false
					$Drill.play("Drill_Up")
			
			if player_depth == 3:
				if $Layer5.get_cellv(player_position) == 2:
					$FX/Not_Available.play()
				else:
					$FX/DiveUp.play()
					can_move = false
					$Drill.play("Drill_Up")
			
			if player_depth == 4:
				$FX/Not_Available.play()
			
	#		player_depth += 1
		elif Input.is_action_just_pressed("dive_up") and player_depth >= 0:
			
			if player_depth == 0:
				$FX/Not_Available.play()
			if player_depth == 1:
				if $Layer1.get_cellv(player_position) == 2:
					$FX/Not_Available.play()
				else:
					$FX/DiveDown.play()
					can_move = false
					$Drill.play("Drill_Down")
					player_depth -= 1
					update_sonar()
					itens_around()
					check_player_depth()
					
			if player_depth == 2:
				if $Layer2.get_cellv(player_position) == 2:
					$FX/Not_Available.play()
				else:
					$FX/DiveDown.play()
					can_move = false
					$Drill.play("Drill_Down")
					player_depth -= 1
					update_sonar()
					itens_around()
					check_player_depth()
			
			if player_depth == 3:
				if $Layer3.get_cellv(player_position) == 2:
					$FX/Not_Available.play()
				else:
					$FX/DiveDown.play()
					can_move = false
					$Drill.play("Drill_Down")
					player_depth -= 1
					update_sonar()
					itens_around()
					check_player_depth()
			
			if player_depth == 4:
				if $Layer4.get_cellv(player_position) == 2:
					$FX/Not_Available.play()
				else:
					$FX/DiveDown.play()
					can_move = false
					$Drill.play("Drill_Down")
					player_depth -= 1
					update_sonar()
					itens_around()
					check_player_depth()
		
		
		
		#CHANGE LAYER MECANISM: HIDE ITENS AND OTHER LAYERS
#			if player_depth == 0:
#				depth_layer_node = $Layer1
#				$Layer1.set_visible(true)
#				$Layer2.set_visible(false)
#				$Layer3.set_visible(false)
#				$Layer4.set_visible(false)
#				$Layer5.set_visible(false)
#
#				show_layer1_itens()
#				hide_layer2_itens()
#				hide_layer3_itens()
#
#			elif player_depth == 1:
#				depth_layer_node = $Layer2
#				$Layer1.set_visible(false)
#				$Layer2.set_visible(true)
#				$Layer3.set_visible(false)
#				$Layer4.set_visible(false)
#				$Layer5.set_visible(false)
#
#				hide_layer1_itens()
#				show_layer2_itens()
#				hide_layer3_itens()
#
#
#
#			if player_depth == 2:
#				depth_layer_node = $Layer3
#				$Layer1.set_visible(false)
#				$Layer2.set_visible(false)
#				$Layer3.set_visible(true)
#				$Layer4.set_visible(false)
#				$Layer5.set_visible(false)
#
#				hide_layer1_itens()
#				hide_layer2_itens()
#				show_layer3_itens()
#
#			if player_depth == 3:
#				depth_layer_node = $Layer4
#				$Layer1.set_visible(false)
#				$Layer2.set_visible(false)
#				$Layer3.set_visible(false)
#				$Layer4.set_visible(true)
#				$Layer5.set_visible(false)
#
#				hide_layer1_itens()
#				hide_layer2_itens()
#				hide_layer3_itens()
#
#			if player_depth == 4:
#				depth_layer_node = $Layer5
#				$Layer1.set_visible(false)
#				$Layer2.set_visible(false)
#				$Layer3.set_visible(false)
#				$Layer4.set_visible(false)
#				$Layer5.set_visible(true)
#
#				hide_layer1_itens()
#				hide_layer2_itens()
#				hide_layer3_itens()
#
		
			
			
		
		#aim the next drill 
		
		if Input.is_action_just_pressed("left"):
			first_movement_click = "left"
		if Input.is_action_just_pressed("right"):
			first_movement_click = "right"
		if Input.is_action_just_pressed("up"):
			first_movement_click = "up"
		if Input.is_action_just_pressed("down"):
			first_movement_click = "down"
			
		
		if Input.is_action_just_pressed("Tool"):
			
			if pica_using_times <= 0:
				current_tool = "Drill"
				$FX/Not_Available.play()
			else:
				if current_tool == "Drill":
					$FX/Control_Switch.play()
					current_tool = "Pica"
				elif current_tool == "Pica":
					$FX/Control_Switch.play()
					current_tool = "Drill"
	
	elif end_game == "Loose": #cant move
		
		if cursor_you_loose == 0:
			$HUD/You_Loose.play("Retry")
			if Input.is_action_just_pressed("Enter"):
				$FX/Control_Enter.play()
				get_tree().reload_current_scene()
		if cursor_you_loose == 1:
			$HUD/You_Loose.play("Menu")
			if Input.is_action_just_pressed("Enter"):
				$FX/Control_Enter.play()
				get_tree().change_scene("res://Menu.tscn")
		if cursor_you_loose == 2:
			$HUD/You_Loose.play("Quit")
			if Input.is_action_just_pressed("Enter"):
				$FX/Control_Enter.play()
				get_tree().quit()
		
		
		if Input.is_action_just_pressed("left"):
			$FX/Control_Switch.play()
			cursor_you_loose -= 1
			cursor_you_loose = clamp(cursor_you_loose, 0, 2)
			
			
		if Input.is_action_just_pressed("right"):
			$FX/Control_Switch.play()
			cursor_you_loose += 1
			cursor_you_loose = clamp(cursor_you_loose, 0, 2)
	
	elif end_game == "Win": #cant move
		if cursor_you_loose == 0:
			$HUD/You_Win.play("Retry")
			if Input.is_action_just_pressed("Enter"):
				$FX/Control_Enter.play()
				get_tree().reload_current_scene()
		if cursor_you_loose == 1:
			$HUD/You_Win.play("Menu")
			if Input.is_action_just_pressed("Enter"):
				$FX/Control_Enter.play()
				get_tree().change_scene("res://Menu.tscn")
		if cursor_you_loose == 2:
			$HUD/You_Win.play("Quit")
			if Input.is_action_just_pressed("Enter"):
				$FX/Control_Enter.play()
				get_tree().quit()
				
		if Input.is_action_just_pressed("left"):
			$FX/Control_Switch.play()
			cursor_you_loose -= 1
			cursor_you_loose = clamp(cursor_you_loose, 0, 2)
			
			$HUD/You_Loose.play()
		if Input.is_action_just_pressed("right"):
			$FX/Control_Switch.play()
			cursor_you_loose += 1
			cursor_you_loose = clamp(cursor_you_loose, 0, 2)
	
	elif can_move == false:
		pass

func move_player():
	

	$PlayerLayer.set_cell(player_position.x, player_position.y, -1)
#	if player_position + direction >= Vector2(0,0) or player_position + direction <= Vector2(8,8):
	player_position += direction
	$PlayerLayer.set_cell(player_position.x, player_position.y, 0)
	direction = Vector2.ZERO
	update_sonar()
	itens_around()
	can_move = true
	
func update_sonar():
	bombs_in_sonar_range = 0
	bones_in_sonar_range = 0
	
	sonar_array.clear()
	sonar_array.append(player_position + Vector2(-1, -1))
	sonar_array.append(player_position + Vector2(0, -1))
	sonar_array.append(player_position + Vector2(1, -1))
	
	sonar_array.append(player_position + Vector2(-1, 0))
	sonar_array.append(player_position + Vector2(1, 0))
	
	sonar_array.append(player_position + Vector2(-1, 1))
	sonar_array.append(player_position + Vector2(0, 1))
	sonar_array.append(player_position + Vector2(1, 1))

	

	
	
	
	
func break_tile():
	if layer1_array.has(player_position) and player_depth == 0:
		$Layer1.set_cell(player_position.x, player_position.y, 1)
	if layer2_array.has(player_position) and player_depth == 1:
		$Layer2.set_cell(player_position.x, player_position.y, 1)
	if layer3_array.has(player_position) and player_depth == 2:
		$Layer3.set_cell(player_position.x, player_position.y, 1)
	if layer4_array.has(player_position) and player_depth == 3:
		$Layer4.set_cell(player_position.x, player_position.y, 1)
	if layer5_array.has(player_position) and player_depth == 4:
		$Layer5.set_cell(player_position.x, player_position.y, 1)
	


func _on_Drill_animation_finished():
	
	if $Drill.get_animation() == "Drill":
		if current_tool == "Drill":
			move_player()
		elif current_tool == "Pica":
			can_move = true
			pica_using_times -= 1
			if pica_using_times <= 0:
				$FX/Not_Available.play()
			
			
#			Break pica tile
			if layer1_array.has(aim_tile) and player_depth == 0:
				$Layer1.set_cell(aim_tile.x, aim_tile.y, 1)
			if layer2_array.has(aim_tile) and player_depth == 1:
				$Layer2.set_cell(aim_tile.x, aim_tile.y, 1)
			if layer3_array.has(aim_tile) and player_depth == 2:
				$Layer3.set_cell(aim_tile.x, aim_tile.y, 1)
			
		$Drill.stop()
		$Drill.set_frame(0)
		$Tile_Crack.stop()
		$Tile_Crack.set_frame(0)
	
	if $Drill.get_animation() == "Drill_Down":
		$Drill.play("Drill")
		$Drill.set_frame(0)
		$Drill.stop()
		can_move = true
		
	if $Drill.get_animation() == "Drill_Up":
		$Drill.play("Drill")
		$Drill.set_frame(0)
		$Drill.stop()
		player_depth += 1
		can_move = true
		update_sonar()
		itens_around()
		check_player_depth()
		
func check_player_depth():
		if player_depth == 0:
				depth_layer_node = $Layer1
				$Layer1.set_visible(true)
				$Layer2.set_visible(false)
				$Layer3.set_visible(false)
				$Layer4.set_visible(false)
				$Layer5.set_visible(false)
				
				show_layer1_itens()
				hide_layer2_itens()
				hide_layer3_itens()
				hide_layer4_itens()
				hide_layer5_itens()
				
		elif player_depth == 1:
			depth_layer_node = $Layer2
			$Layer1.set_visible(false)
			$Layer2.set_visible(true)
			$Layer3.set_visible(false)
			$Layer4.set_visible(false)
			$Layer5.set_visible(false)
			
			hide_layer1_itens()
			show_layer2_itens()
			hide_layer3_itens()
			hide_layer4_itens()
			hide_layer5_itens()
			
			
			
		if player_depth == 2:
			depth_layer_node = $Layer3
			$Layer1.set_visible(false)
			$Layer2.set_visible(false)
			$Layer3.set_visible(true)
			$Layer4.set_visible(false)
			$Layer5.set_visible(false)
			
			hide_layer1_itens()
			hide_layer2_itens()
			show_layer3_itens()
			hide_layer4_itens()
			hide_layer5_itens()
			
		
		if player_depth == 3:
			depth_layer_node = $Layer4
			$Layer1.set_visible(false)
			$Layer2.set_visible(false)
			$Layer3.set_visible(false)
			$Layer4.set_visible(true)
			$Layer5.set_visible(false)
			
			hide_layer1_itens()
			hide_layer2_itens()
			hide_layer3_itens()
			show_layer4_itens()
			hide_layer5_itens()
			
		if player_depth == 4:
			depth_layer_node = $Layer5
			$Layer1.set_visible(false)
			$Layer2.set_visible(false)
			$Layer3.set_visible(false)
			$Layer4.set_visible(false)
			$Layer5.set_visible(true)
			
			hide_layer1_itens()
			hide_layer2_itens()
			hide_layer3_itens()
			hide_layer4_itens()
			show_layer5_itens()
			
		

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
	
	for i in itens_layer4:
		if i[1] == area:
			itens_layer4.erase(i)
	
	for i in itens_layer5:
		if i[1] == area:
			itens_layer5.erase(i)
	
	if area.is_in_group("bones"):
		$FX/Find_Bone.play()
		score += 1
		$HUD/Itens.text = String(score)
	
		area.queue_free()
	
	if area.is_in_group("bomb"):
		life -= 1
		$HUD/Lifes.text = String(life)

func choose(array):
	return array[randi() % array.size()]	

func randomize_itens_in_matrix():
	
	[0, 1, 2]
	

	itens_layer1.append_array(random_itens_in_quadrant([3, 4, 5], [3, 4, 5]))

	
	itens_layer2.append_array(random_itens_in_quadrant([2, 3, 4], [2, 3]))
	itens_layer2.append_array(random_itens_in_quadrant([5, 6], [2, 3, 4]))
	itens_layer2.append_array(random_itens_in_quadrant([2, 3], [4, 5, 6]))
	itens_layer2.append_array(random_itens_in_quadrant([4, 5, 6], [5, 6]))

	
	itens_layer3.append_array(random_itens_in_quadrant([1, 2, 3], [1, 2, 3]))
	itens_layer3.append_array(random_itens_in_quadrant([1, 2, 3], [5, 6, 7]))
	itens_layer3.append_array(random_itens_in_quadrant([5, 6, 7], [1, 2, 3]))
	itens_layer3.append_array(random_itens_in_quadrant([5, 6, 7], [5, 6, 7]))
	itens_layer3.append_array(random_itens_in_quadrant([4], [1, 2, 3, 4, 5, 6, 7]))
	itens_layer3.append_array(random_itens_in_quadrant([1, 2, 3, 4, 5, 6, 7], [4]))


	itens_layer4.append_array(random_itens_in_quadrant([0, 1, 2], [0, 1, 2]))
	itens_layer4.append_array(random_itens_in_quadrant([0, 1, 2], [3, 4, 5]))
	itens_layer4.append_array(random_itens_in_quadrant([0, 1, 2], [6, 7, 8]))
	itens_layer4.append_array(random_itens_in_quadrant([3, 4, 5], [0, 1, 2]))
	itens_layer4.append_array(random_itens_in_quadrant([3, 4, 5], [3, 4, 5]))
	itens_layer4.append_array(random_itens_in_quadrant([3, 4, 5], [6, 7, 8]))
	itens_layer4.append_array(random_itens_in_quadrant([6, 7, 8], [0, 1, 2]))
	itens_layer4.append_array(random_itens_in_quadrant([6, 7, 8], [3, 4, 5]))
	itens_layer4.append_array(random_itens_in_quadrant([6, 7, 8], [6, 7, 8]))
	
	
	itens_layer5.append_array(random_itens_in_quadrant([1, 2, 3], [0, 1, 2]))
	itens_layer5.append_array(random_itens_in_quadrant([5, 6, 7], [0, 1, 2]))
	itens_layer5.append_array(random_itens_in_quadrant([1, 2, 3], [3, 4, 5]))
	itens_layer5.append_array(random_itens_in_quadrant([5, 6, 7], [3, 4, 5]))
	itens_layer5.append_array(random_itens_in_quadrant([1, 2, 3], [6, 7, 8]))
	itens_layer5.append_array(random_itens_in_quadrant([5, 6, 7], [6, 7, 8]))
	
	print(all_itens)

	
#	print(itens_layer1)
	
		

func random_itens_in_quadrant(arrayx,arrayy):
	
	var Q1 = []
	
	
	
	
	randomize()
	var Q1_choose_position
	Q1_choose_position = Vector2(choose(arrayx), choose(arrayy))
	while Q1_choose_position == Vector2(4,4):
		Q1_choose_position = Vector2(choose(arrayx), choose(arrayy))
	
	var object = choose(all_itens)
	all_itens.erase(object)
	
	object.position.x = Q1_choose_position.x * tile_size.x + tile_size.x/2
	object.position.y = Q1_choose_position.y * tile_size.y + tile_size.y/2
#	object.set_visible(true)
#	print(object.get_global_position())
#	print(all_itens.size())
#	print(object)
	
	

	randomize()
	var last_Q1_choose_position = Vector2()
	last_Q1_choose_position = Vector2(choose(arrayx), choose(arrayy))
	while Q1_choose_position == last_Q1_choose_position or last_Q1_choose_position == Vector2(4,4):
		randomize()
		last_Q1_choose_position = Vector2(choose(arrayx), choose(arrayy))
	var last_object = choose(all_itens)
	all_itens.erase(last_object)
	if last_Q1_choose_position == Vector2(0, 0):
		last_object.position = tile_size/Vector2(2,2)
	else:
		last_object.position = last_Q1_choose_position * tile_size + tile_size/ Vector2(2,2)
#		last_object.set_visible(false)
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
		
func hide_layer4_itens():
#	print (itens_layer3.size())
	for i in itens_layer4:
		
		i[1].position = Vector2(500,500)

func hide_layer5_itens():
#	print (itens_layer3.size())
	for i in itens_layer5:
		
		i[1].position = Vector2(500,500)

func show_layer1_itens():
#	print (itens_layer1.size())
	for i in itens_layer1:
	
		i[1].position = i[0] * tile_size + tile_size/Vector2(2,2)

func show_layer2_itens():
#	print (itens_layer2.size())
	for i in itens_layer2:
		
		i[1].position = i[0] * tile_size + tile_size/Vector2(2,2)

func show_layer3_itens():
#	print (itens_layer3.size())
	for i in itens_layer3:
#		
		i[1].position = i[0] * tile_size + tile_size/Vector2(2,2)
		
func show_layer4_itens():
#	print (itens_layer3.size())
	for i in itens_layer4:
#		
		i[1].position = i[0] * tile_size + tile_size/Vector2(2,2)
		
func show_layer5_itens():
#	print (itens_layer3.size())
	for i in itens_layer5:
#		
		i[1].position = i[0] * tile_size + tile_size/Vector2(2,2)
		
func itens_around():
	if player_depth == 0:
		for i in sonar_array:
			for j in itens_layer1:
				if i == j[0]:
					if j[1].is_in_group("bomb"):
						bombs_in_sonar_range += 1
#						print("BOMB_COUNT: " + String(bombs_in_sonar_range))
					elif j[1].is_in_group("bones"):
						bones_in_sonar_range += 1
#						print("BONE_COUNT: " + String(bones_in_sonar_range))
		$HUD/Bomb.text = String(bombs_in_sonar_range)
		$HUD/Bone.text = String(bones_in_sonar_range)
	
	
	if player_depth == 1:
		for i in sonar_array:
			for j in itens_layer2:
				if i == j[0]:
					if j[1].is_in_group("bomb"):
						bombs_in_sonar_range += 1
#						
					elif j[1].is_in_group("bones"):
						bones_in_sonar_range += 1
		$HUD/Bomb.text = String(bombs_in_sonar_range)
		$HUD/Bone.text = String(bones_in_sonar_range)

	
	if player_depth == 2:
		for i in sonar_array:
			for j in itens_layer3:
				if i == j[0]:
					if j[1].is_in_group("bomb"):
						bombs_in_sonar_range += 1
#					
					elif j[1].is_in_group("bones"):
						bones_in_sonar_range += 1
		$HUD/Bomb.text = String(bombs_in_sonar_range)
		$HUD/Bone.text = String(bones_in_sonar_range)
	
	if player_depth == 3:
		for i in sonar_array:
			for j in itens_layer4:
				if i == j[0]:
					if j[1].is_in_group("bomb"):
						bombs_in_sonar_range += 1
#					
					elif j[1].is_in_group("bones"):
						bones_in_sonar_range += 1
		$HUD/Bomb.text = String(bombs_in_sonar_range)
		$HUD/Bone.text = String(bones_in_sonar_range)
	
	if player_depth == 4:
		for i in sonar_array:
			for j in itens_layer5:
				if i == j[0]:
					if j[1].is_in_group("bomb"):
						bombs_in_sonar_range += 1
#					
					elif j[1].is_in_group("bones"):
						bones_in_sonar_range += 1
		$HUD/Bomb.text = String(bombs_in_sonar_range)
		$HUD/Bone.text = String(bones_in_sonar_range)
		
		
		# COLOCAR AS OUTRAS DUAS CAMADAS!!!!!!!!!!!!!!!!!!! ############################
func you_loose():
	end_game = "Loose"
	$HUD/You_Loose.set_visible(true)

func you_win():
	end_game = "Win"
	$HUD/You_Win.set_visible(true)
	




func _on_Radar_finished():
	$FX/Radar/Timer.start()


func _on_Timer_timeout():
	$FX/Radar.play()
