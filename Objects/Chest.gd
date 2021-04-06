extends Node2D

var x
var y
var hit = false

var opened = false

func _process(delta):
	if opened:
		$AnimatedSprite.animation = "open"


func open():
	opened = true
	




func _on_Area2D_mouse_entered():
	hit = true
	pass # Replace with function body.


func _on_Area2D_mouse_exited():
	hit = false
	pass # Replace with function body.
