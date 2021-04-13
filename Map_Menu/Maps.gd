extends Node2D

func _ready():
	var files = list_files()
	for x in files:
		var size = Vector2(100,50)
		var buttonLoad = Button.new()
		buttonLoad.set_name("Load_"+x)
		buttonLoad.text = x
		buttonLoad.rect_min_size = size
		
		size = Vector2(50,50)
		var buttonEdit = Button.new()
		buttonEdit.set_name("Edit_"+x)
		buttonEdit.rect_min_size = size
		
		var buttonDelete = Button.new()
		buttonDelete.set_name("Delete_"+x)
		buttonDelete.rect_min_size = size
		
		$ScrollContainer/HBoxContainer/LoadContainer.add_child(buttonLoad)
		$ScrollContainer/HBoxContainer/EditContainer.add_child(buttonEdit)
		$ScrollContainer/HBoxContainer/DeleteContainer.add_child(buttonDelete)
		buttonLoad.connect("pressed", self, "_on_ButtonLoad_pressed", [x])
		buttonEdit.connect("pressed", self, "_on_ButtonEdit_pressed", [x])
		buttonDelete.connect("pressed", self, "_on_ButtonDelete_pressed", [x])
	#print_tree_pretty()
	pass # Replace with function body.

func _input(event):
	update()

func list_files():
	var files = []
	var dir = Directory.new()
	dir.open("res://Map_Menu/Maps/")
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file.get_basename())
		
	dir.list_dir_end()
		
	return files

func find_node_by_name(root, name):
	if(root.get_name() == name): return root
	
	for child in root.get_children():
		if(child.get_name() == name):
			return child
			
		var found = find_node_by_name(child, name)
		
		if(found): return found
		
	return null

func _on_ButtonBack_pressed():
	get_tree().change_scene("res://Main_Menu/Main_Main.tscn")
	pass # Replace with function body.

func _on_ButtonLoad_pressed(name):
	Global.loading = name
	print(Global.loading)
	get_tree().change_scene("res://Map_Sim/Main_Sim.tscn")
	pass
	
func _on_ButtonEdit_pressed(name):
	Global.editing = name
	print(Global.editing)
	get_tree().change_scene("res://Map_Edit/Main_Edit.tscn")
	pass
	
func _on_ButtonDelete_pressed(name):
	var file = File.new()
	if file.file_exists("res://Map_Menu/Maps/"+name+".tscn"):
		var dir = Directory.new()
		dir.remove("res://Map_Menu/Maps/"+name+".tscn")
		var temp = find_node_by_name(get_tree().get_root(), "Load_"+name)
		$ScrollContainer/HBoxContainer/LoadContainer.remove_child(temp)
		temp = find_node_by_name(get_tree().get_root(), "Edit_"+name)
		$ScrollContainer/HBoxContainer/EditContainer.remove_child(temp)
		temp = find_node_by_name(get_tree().get_root(), "Delete_"+name)
		$ScrollContainer/HBoxContainer/DeleteContainer.remove_child(temp)
	update()
	pass


