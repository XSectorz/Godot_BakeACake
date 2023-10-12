extends Node2D

func _spawn(loc):
	position.x = (loc.x*32)+16
	position.y = (loc.y*32)+16
