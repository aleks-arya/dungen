extends Node2D

var x
var y
export var hitpoints = 10
export var move_range = 6

var hit = false

var dead = false
onready var sprite = $AnimatedSprite

func _process(delta):
	if dead:
		$AnimatedSprite.animation = "dead"
		

func die():
	dead = true
	




func _on_Area2D_mouse_entered():
	hit = true
	pass # Replace with function body.


func _on_Area2D_mouse_exited():
	hit = false
	pass # Replace with function body.


func _on_Area2D_input_event(viewport, event, shape_idx):
	pass # Replace with function body.
