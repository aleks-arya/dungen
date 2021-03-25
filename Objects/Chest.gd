extends Node2D

var x
var y

var opened = false

func _process(delta):
	if opened:
		$AnimatedSprite.animation = "open"


func open():
	opened = true
	


