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
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
			var cords = get_node("./Terrain").world_to_map(get_global_mouse_position())
			if $Terrain.get_cell(cords.x, cords.y) == 0:
				var object = load("res://Objects/"+active_left+".tscn").instance()
				object.set_name(active_left)
				$Terrain.add_child(object)
				object.position = get_global_mouse_position()
				object.x = cords.x
				object.y = cords.y
			pass
			#place object
		if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
			pass
			#destroy object



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
