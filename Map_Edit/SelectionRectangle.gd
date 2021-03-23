extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var dragging = false
var drag_start = Vector2.ZERO
var color = Color(1,1,1)

func _unhandled_input(event):
	if event is InputEventMouseButton and (event.button_index == BUTTON_LEFT or event.button_index == BUTTON_RIGHT):
		if event.button_index == BUTTON_LEFT:
			color = Color(1,1,1, 0.6)
		elif event.button_index == BUTTON_RIGHT:
			color = Color(0.86, 0.08, 0.24, 0.5)
		if event.pressed:
			dragging = true
			drag_start = get_global_mouse_position()
		elif dragging:
			dragging = false
			update()
	if event is InputEventMouseMotion and dragging:
		update()

func _draw():
	if dragging:
		draw_rect(Rect2(drag_start, get_global_mouse_position()-drag_start), color, false)
