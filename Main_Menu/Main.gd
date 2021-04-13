extends Node2D


func _on_ButtonGen_pressed():
	Global.editing = ""
	get_tree().change_scene("res://Map_Gen/Main_Gen.tscn")
	pass # Replace with function body.


func _on_ButtonSim_pressed():
	get_tree().change_scene("res://Map_Menu/Maps.tscn")
	pass # Replace with function body.
