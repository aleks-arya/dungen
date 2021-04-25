extends Node2D

var players = []
var monsters = []
var objects = []
var combat = []
var unseen_monsters = []
var turn = 0



func _init():
	print("hello there")

func _ready():
	print(Global.loading)
	var map = load("res://Map_Menu/Maps/"+Global.loading+".tscn").instance()
	$T.add_child(map)
	map.name = "Terrain"
	
	players = get_tree().get_nodes_in_group("Players")
	for player in players:
		player.cell = $T/Terrain.world_to_map(player.position)
		
	monsters = get_tree().get_nodes_in_group("Monsters")
	for monster in monsters:
		monster.cell = $T/Terrain.world_to_map(monster.position)
		
	objects = get_tree().get_nodes_in_group("Objects")
	for object in objects:
		object.cell = $T/Terrain.world_to_map(object.position)
	
	combat = players.duplicate()
	unseen_monsters = monsters.duplicate()
	
	if combat != []:
		Global.active = combat[turn]
		
	$Movement.position = $T/Terrain.position
	$Visibility.position = $T/Terrain.position
	
	var cells = $T/Terrain.get_used_cells()
	for cell in cells:
		$Visibility.set_cellv(cell, 0)

func _input(event):
	if Input.is_action_pressed("ui_left"):
		prev_turn()
	if Input.is_action_pressed("ui_right"):
		next_turn()
	
	if Input.is_action_pressed("key_m"):
		if Global.active != null:
			Global.active.temp_move = Global.active.move_range
			draw_movement(Global.active.move_range)
		pass
		
	if Input.is_action_pressed("ui_cavegen"):
		if Global.active != null and Global.active.is_in_group("Players"):
			remove_fog(Global.active)
		pass
	
	if Input.is_mouse_button_pressed(1):
		if Global.active != null:
			move()

func _process(delta):
	for player in players:
		remove_fog(player)
		scan_for_monsters()
	pass

func prev_turn():
	turn = turn - 1
	if turn < 0:
		turn = combat.size()-1
	Global.active = combat[turn]
	
	Global.active.temp_move = Global.active.move_range
	draw_movement(Global.active.move_range)

func next_turn():
	turn = turn + 1
	if turn > combat.size()-1:
		turn = 0
	Global.active = combat[turn]
	
	Global.active.temp_move = Global.active.move_range
	draw_movement(Global.active.move_range)

func move():
	var cords = $Movement.world_to_map(get_global_mouse_position())
	if $Movement.get_cellv(cords) != -1:
		var moved = ceil((Global.active.cell - cords).length())
		Global.active.position = $Movement.map_to_world(cords) + Vector2(16,16)
		Global.active.cell = cords
		Global.active.temp_move = Global.active.temp_move - moved
		draw_movement(Global.active.temp_move)

func is_empty(cell: Vector2):
	if $T/Terrain.get_cell(cell.x, cell.y) != 0:
		return false
	
	for obstacle in combat:
		if obstacle.cell == cell:
			return false
	
	for obstacle in objects:
		if obstacle.cell == cell:
			return false
	return true

func draw_movement(move_range):
	$Movement.clear()
	var to_fill = Global.active.cell
	
	var type
	if Global.active in players:
		type = 0
	else:
		type = 1
	
	flood_fill_alg(to_fill, move_range, type)
	
	pass

func flood_fill_alg(tile, move_range, type):
	if move_range <= 0:
		return

	#check adjacent cells
	var north = Vector2(tile.x, tile.y-1)
	var south = Vector2(tile.x, tile.y+1)
	var east  = Vector2(tile.x+1, tile.y)
	var west  = Vector2(tile.x-1, tile.y)

	for dir in [north,south,east,west]:
		if is_empty(dir):
			$Movement.set_cellv(dir, type)
			flood_fill_alg(dir, move_range-1, type)

	pass

func remove_fog(player):
	$Visibility.set_cellv(player.cell, -1)

	var view_range = player.view_range
	var square = get_square(player.cell, view_range)

	for point in square:
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(player.position, $Visibility.map_to_world(point), [Shape2D])
		
		if result:
			var pos = $Visibility.world_to_map(result.position - result.normal)
			var length = (pos - player.cell).length()
			
			if length < view_range:
				$Visibility.set_cellv(pos, -1)

func get_square(centre: Vector2, radius):
	var up = centre.y - radius
	var down = centre.y + radius
	var left = centre.x - radius
	var right = centre.x + radius
	
	var points = []
	
	for x in range(left, right+1):
		points.append(Vector2(x, up))
		points.append(Vector2(x, down))

	for y in range(up+1, down):
		points.append(Vector2(left, y))
		points.append(Vector2(right, y))
	
	return points

func scan_for_monsters():
	for monster in unseen_monsters:
		if !combat.has(monster):
			if $Visibility.get_cellv(monster.cell):
				combat.append(monster)
				unseen_monsters.erase(monster)

func _on_ButtonBack_pressed():
	var file = File.new()
	if file.file_exists("res://Map_Menu/Maps/"+Global.loading+".tscn"):
		var packed_scene = PackedScene.new()
		packed_scene.pack(get_tree().get_root().get_node("/root/Main_Sim/T/Terrain"))
		ResourceSaver.save("res://Map_Menu/Maps/"+Global.loading+".tscn", packed_scene)
		print(Global.loading)
	get_tree().change_scene("res://Map_Menu/Maps.tscn")
	pass # Replace with function body.
