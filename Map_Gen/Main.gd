tool
extends Node2D

export(bool) var draw_dung setget draw_dung
export(bool)  var draw_caves  setget draw_caves

export(int)   var map_w         = 80
export(int)   var map_h         = 50


# this scene exists solely to run redraw on Caves.tscn
# without the tilemap selected, so the grid isn't shown in
# the webp animation on the blog post

func _input(event):
	if event.is_action_pressed('ui_cavegen'):
		draw_caves()
	if event.is_action_pressed('ui_dunggen'):
		draw_dung()



func draw_dung(value = null):
	# only do this if we are working in the editor
#	if !Engine.is_editor_hint(): return
	$Caves.visible = false
	$Dungeon.visible = true
	$Dungeon.redraw()
	
func draw_caves(value = null):
	# only do this if we are working in the editor
#	if !Engine.is_editor_hint(): return
	$Caves.visible = true
	$Dungeon.visible = false
	$Caves.redraw()

func save_map():
	pass


func _on_Button_Cave_pressed():
	draw_caves()
	# Replace with function body.

func _on_Button_Dung_pressed():
	draw_dung()
	# Replace with function body.

func _on_Button_Back_pressed():
	get_tree().change_scene("res://Main_Menu/Main.tscn")
	# Replace with function body.
