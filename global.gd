extends Node

var map_w = 66
var map_h = 66

var loading = ""
var editing = ""

var active = ""

func find_node_by_name(root, name):
	if(root.get_name() == name): return root
	
	for child in root.get_children():
		if(child.get_name() == name):
			return child
			
		var found = find_node_by_name(child, name)
		
		if(found): return found
		
	return null
