extends TileMap

enum Tiles { GROUND, ROOF, TREE, WATER}
export(int)   var map_w           = 80
export(int)   var map_h           = 50

const load_dir = "user://temporary_map.txt"

func _ready():
	load_map()
	pass
	
func _process(delta):
	
	pass
	
func load_map():
	var file = File.new()
	if file.file_exists(load_dir):
		file.open(load_dir, File.READ)
		map_w = str2var(file.get_line())
		map_h = str2var(file.get_line())

		for y in map_h:
			for x in map_w:
				var line = str2var(file.get_line())
				set_cell(x,y,line)
				#print(typeof(line) == TYPE_ARRAY)
				#set_cell(line[1], line[2], line[3])
			
		file.close()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
