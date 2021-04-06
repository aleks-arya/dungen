tool
extends Node2D

export(bool) var draw_dung setget draw_dung
export(bool)  var draw_caves  setget draw_caves

export(int)   var map_w         = 66
export(int)   var map_h         = 66
var room_size     = 2
var density       = 2

var saved
var save_dir = "user://temporary_map.txt"


func draw_dung(value = null):
#	if !Engine.is_editor_hint(): return
	$Dungeon.visible = true
	$Caves.visible = false
	$Dungeon.redraw()
	
func draw_caves(value = null):
#	if !Engine.is_editor_hint(): return
	$Dungeon.visible = false
	$Caves.visible = true
	$Caves.redraw()

func update_dung_variables():
	$Dungeon.map_w = map_w
	$Dungeon.map_h = map_h
	$Dungeon.min_room_size = 6 + room_size
	$Dungeon.min_room_factor = 0.25 + 0.05*density


func update_cave_variables():
	$Caves.map_w = map_w
	$Caves.map_h = map_h
	$Caves.min_cave_size = 60 + 20*room_size
	$Caves.ground_chance = 46 + 2*density

func update_camera_variables():
	$Camera2D.mapW = map_w
	$Camera2D.mapH = map_h


func _on_Button_Dung_pressed():
	update_dung_variables()
	update_camera_variables()
	$Camera2D.recentre()
	draw_dung()

func _on_Button_Cave_pressed():
	update_cave_variables()
	update_camera_variables()
	$Camera2D.recentre()
	draw_caves()

func _on_Button_Back_pressed():
	get_tree().change_scene("res://Main_Menu/Main_Main.tscn")
	# Replace with function body.

func _on_Button_Edit_pressed():
	var tilemap
	if $Dungeon.visible == true:
		tilemap = $Dungeon
	else:
		tilemap = $Caves
	
	var file = File.new()
	file.open(save_dir, File.WRITE)
	var vectors = tilemap.get_used_cells()
	file.store_line(var2str(map_w))
	file.store_line(var2str(map_h))
	for chunk in vectors:
		var tile = tilemap.get_cell(chunk.x, chunk.y)
		file.store_line(var2str(tile))
		
	file.close()
	get_tree().change_scene("res://Map_Edit/Main_Edit.tscn")

func return_small_big(value):
	if value == 0:
		return "Tiny"
	elif value == 1:
		return "Small"
	elif value == 2:
		return "Medium"
	elif value == 3:
		return "Big"
	elif value == 4:
		return "Huge"
	else:
		return "Null"


func _on_HSlider_Width_value_changed(value):
	map_w = 42 + int(value*12)
	$Camera2D/CanvasLayer/Modifiers/Label_Width.text = "Width: "+return_small_big(value)
	pass # Replace with function body.

func _on_HSlider_Height_value_changed(value):
	map_h = 42 + int(value*12)
	$Camera2D/CanvasLayer/Modifiers/Label_Height.text = "Height: "+return_small_big(value)
	pass # Replace with function body.

func _on_HSlider_RoomSize_value_changed(value):
	room_size = value
	$Camera2D/CanvasLayer/Modifiers/Label_RoomSize.text = "Room size: "+return_small_big(value)
	pass # Replace with function body.

func _on_HSlider_Density_value_changed(value):
	density = value
	$Camera2D/CanvasLayer/Modifiers/Label_Density.text = "Density: "+return_small_big(value)
	pass # Replace with function body.
