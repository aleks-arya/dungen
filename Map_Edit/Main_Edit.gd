extends Node2D

enum Tiles { GROUND, ROOF, TREE, WATER}

var active_left = Tiles.GROUND
var active_right = Tiles.ROOF
var active = active_left
var color = Color(0.85, 0.65, 0.13, 1)

var dragging = false
var drag_start = Vector2.ZERO

var tiling = true

func _ready():
	if Global.editing == "":
		$Terrain.load_gen_map()
		$Terrain.update_bitmask_region()
	else:
		var map = load("user://saves/"+Global.editing+".scn").instance()
		remove_child($Terrain)
		add_child(map)
		map.name = "Terrain"
		map.update_bitmask_region()
		$Camera2D/CanvasLayer/LineEditSave.text = Global.editing


func _unhandled_input(event):
	if tiling:
		#terrain
		if event is InputEventMouseButton and (event.button_index == BUTTON_LEFT or event.button_index == BUTTON_RIGHT):
			var cords = get_node("./Terrain").world_to_map(get_global_mouse_position())
			if get_node("./Terrain").get_cell(cords.x, cords.y) != -1:
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
					$Terrain.update_bitmask_region()
		if event is InputEventMouseMotion and dragging:
			update()
			$Terrain.update_bitmask_region()
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
					object.set_owner($Terrain)
					print(object.name)
					#object.sprite.set_modulate(Color(randf(),randf(),randf()))
					object.position = $Terrain.map_to_world(cords) + Vector2(16,16)
					object.cell = cords
					
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
	color = Color(0.85, 0.65, 0.13, 1)
	pass # Replace with function body.

#----------------------------------players
func _on_ButtonPlayerMage_pressed():
	tiling = false
	active_left = "Player"
	pass # Replace with function body.


#----------------------------------monsters
func _on_ButtonBlob_pressed():
	tiling = false
	active_left = "Blob"
	color = Color(0, randf(), 0)
	pass # Replace with function body.


func _on_ButtonRat_pressed():
	tiling = false
	active_left = "Rat"
	var x = randf()
	color = Color(x,x,x)
	pass # Replace with function body.


func _on_ButtonSkeleW_pressed():
	tiling = false
	active_left = "Skeleton_Warrior"
	color = Color( 0.97, 0.97, 1, 1 )
	pass # Replace with function body.


func _on_ButtonSkeleA_pressed():
	tiling = false
	active_left = "Skeleton_Archer"
	color = Color( 0.97, 0.97, 1, 1 )
	pass # Replace with function body.


func _on_ButtonBat_pressed():
	tiling = false
	active_left = "Bat"
	var x = rand_range(0,0.2)
	color = Color(x,x,x)
	pass # Replace with function body.


func _on_ButtonSpider_pressed():
	tiling = false
	active_left = "Spider"
	color = Color(0,0,0)
	pass # Replace with function body.


func _on_ButtonSave_pressed():
	var map_name = $Camera2D/CanvasLayer/LineEditSave.get_text()+".scn"
	var file = File.new()
	if file.file_exists("user://saves/"+map_name):
		if Global.editing == $Camera2D/CanvasLayer/LineEditSave.text:
			print("nadpisuje")
			$Camera2D/CanvasLayer/LabelSave.visible = false
			var packed_scene = PackedScene.new()
			packed_scene.pack(get_tree().get_root().get_node("/root/Main_Edit/Terrain"))
			ResourceSaver.save("user://saves/"+map_name, packed_scene)
		else:
			$Camera2D/CanvasLayer/LabelSave.visible = true
	else:
		print("zapisuje")
		$Camera2D/CanvasLayer/LabelSave.visible = false
		var packed_scene = PackedScene.new()
		packed_scene.pack(get_tree().get_root().get_node("/root/Main_Edit/Terrain"))
		ResourceSaver.save("user://saves/"+map_name, packed_scene)
	pass # Replace with function body.


func _on_ButtonMain_pressed():
	if Global.editing == "":
		get_tree().change_scene("res://Map_Gen/Main_Gen.tscn")
	else:
		get_tree().change_scene("res://Map_Menu/Maps.tscn")
	pass # Replace with function body.



