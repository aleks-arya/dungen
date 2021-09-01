extends Camera2D

var mapW = 66
var mapH = 66

export var zoomspeed = 20.0
export var zoommargin = 0.1

export var zoomMin = 0.25
export var zoomMax = 8.0

var zoomfactor = 1.25
var zooming = false


var follow = true

func _process(delta):
	if Global.active != null:
		if follow:
			var active = Global.active
			position = active.position
	
	zoom.x = lerp(zoom.x, zoom.x * zoomfactor, zoomspeed * delta)
	zoom.y = lerp(zoom.y, zoom.y * zoomfactor, zoomspeed * delta)

	zoom.x = clamp(zoom.x, zoomMin, zoomMax)
	zoom.y = clamp(zoom.y, zoomMin, zoomMax)

	if not zooming:
		zoomfactor = 1.0

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			zooming = true
			if event.button_index == BUTTON_WHEEL_UP:
				zoomfactor -= 0.01 * zoomspeed
			if event.button_index == BUTTON_WHEEL_DOWN:
				zoomfactor += 0.01 * zoomspeed
		else:
			zooming = false


func _on_CheckButton_toggled(button_pressed):
	follow = button_pressed
	
	if follow:
		zoom.x = mapW/75
		zoom.y = mapW/75
	else:
		position.x = mapW/2 * 32
		position.y = mapH/2 * 32
	
		zoom.x = mapW/30
		zoom.y = mapW/30
	pass # Replace with function body.
