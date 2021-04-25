extends Camera2D


func _process(delta):
	var active = Global.active
	position = active.position
