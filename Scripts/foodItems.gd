extends Node2D

var foodType = 0 #0 = มังคุด #1 = ข้าว

func _ready():
	pass
	
func _CreateObject(position_to_create,type):
	position.x = (position_to_create.x*32)+16
	position.y = (position_to_create.y*32)+16
	foodType = type

