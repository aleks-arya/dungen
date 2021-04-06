extends Node2D

enum Tiles { GROUND, ROOF, TREE, WATER}

var active_left = Tiles.GROUND
var active_right = Tiles.ROOF
var active = active_left

var dragging = false
var drag_start = Vector2.ZERO

var tiling = true

func _unhandled_input(event):
	if tiling:
		#terrain
		if event is InputEventMouseButton and (event.button_index == BUTTON_LEFT or event.button_index == BUTTON_RIGHT):
			if event.button_index == BUTTON_LEFT:
				active = active_left
			elif event.button_index == BUTTON_RIGHT:
				active = active_right
			if event.pressed:
				dragging = true
				drag_start = get_node("./Terrain").world_to_map(get_global_mouse_position())
			elif dragging:
				var drag_end = get_node("./Terrain").world_to_map(get_global_mouse_position())
				fill_rect($Terrain, drag_start, drag_end, active)
				dragging = false
				update()
		if event is InputEventMouseMotion and dragging:
			update()
	else:
		#objects
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
			#placing objects (left click)
			var cords = get_node("./Terrain").world_to_map(get_global_mouse_position())
			if $Terrain.get_cell(cords.x, cords.y) == 0:
				var space = get_world_2d().direct_space_state
				var mouse_pos = get_global_mouse_position()
				if !space.intersect_point(mouse_pos, 1, [], 2147483647, true, true):
					var object = load("res://Objects/"+active_left+".tscn").instance()
					object.set_name(active_left+"-"+str(cords.x)+"-"+str(cords.y))
					$Terrain.add_child(object)
					print(object.name)
					object.position.x = $Terrain.map_to_world(cords).x + 16
					object.position.y = $Terrain.map_to_world(cords).y + 16
					object.x = cords.x
					object.y = cords.y
					
		if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
			#removing objects (right click)
			var space = get_world_2d().direct_space_state
			var mouse_pos = get_global_mouse_position()
			if space.intersect_point(mouse_pos, 1, [], 2147483647, true, true):
				var cords = get_node("./Terrain").world_to_map(get_global_mouse_position())
				if $Terrain.get_cell(cords.x, cords.y) != 1:
					var object_name = active_left+"-"+str(cords.x)+"-"+str(cords.y)
					var object = find_node_by_name(get_tree().get_root(), object_name)
					
					$Terrain.remove_child(object)
					print("removed "+object_name)


func find_node_by_name(root, name):
	if(root.get_name() == name): return root
	
	for child in root.get_children():
		if(child.get_name() == name):
			return child
			
		var found = find_node_by_name(child, name)
		
		if(found): return found
		
	return null

func fill_rect(tilemap, start, end, tile):
	if start.x > end.x:
		var temp = start.x
		start.x = end.x
		end.x = temp
	if start.y > end.y:
		var temp = start.y
		start.y = end.y
		end.y = temp
	for i in range(start.x, end.x+1):
		for j in range(start.y, end.y+1):
			tilemap.set_cell(i, j, tile)

#----------------------------------terrain
func _on_ButtonGround_pressed():
	tiling = true
	active_left = Tiles.GROUND
	active_right = Tiles.ROOF

func _on_ButtonRoof_pressed():
	tiling = true
	active_left = Tiles.ROOF
	active_right = Tiles.GROUND

func _on_ButtonWater_pressed():
	tiling = true
	active_left = Tiles.WATER
	active_right = Tiles.GROUND

#----------------------------------objects
func _on_ButtonChest_pressed():
	tiling = false
	active_left = "Chest"
	pass # Replace with function body.
