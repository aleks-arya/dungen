extends Node2D

var cell
export var hitpoints = 10
export var move_range = 4
export var view_range = 7
var temp_move = move_range

var hit = false

var dead = false
onready var sprite = $AnimatedSprite

func _process(delta):
	if dead:
		$AnimatedSprite.animation = "dead"
		

func die():
	dead = true
	

func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_mouse_button_pressed(1):
		if self.get_parent().get_parent().name == "T" and Global.active != self:#left
			Global.active = self
			temp_move = move_range
	pass # Replace with function body.
