extends Node

func _init():
	print("hello there")

func _ready():
	print(Global.loading)
	var map = load("res://Map_Menu/Maps/"+Global.loading+".tscn").instance()
	add_child(map)
	map.name = "Terrain"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
