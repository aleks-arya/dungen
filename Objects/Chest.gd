extends Node2D

var cell
var hit = false

var opened = false
onready var sprite = $AnimatedSprite

func _process(delta):
	if opened:
		$AnimatedSprite.animation = "open"


func open():
	opened = true
	


