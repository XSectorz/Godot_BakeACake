extends Node


#Map Position
var map1Index = [Vector2(176,176),Vector2(208,176),Vector2(240,176),Vector2(272,176),Vector2(272,144),Vector2(272,112),Vector2(272,208),Vector2(272,240),Vector2(304,240),Vector2(336,240)]
var map1VectorData = [Vector2(5,5),Vector2(6,5),Vector2(7,5),Vector2(8,5),Vector2(8,4),Vector2(8,3),Vector2(8,6),Vector2(8,7),Vector2(9,7),Vector2(10,7)
					,Vector2(10,7),Vector2(11,7),Vector2(12,7),Vector2(13,7),Vector2(14,7),Vector2(15,7),Vector2(16,7),Vector2(17,7),Vector2(14,8),Vector2(14,9)
					,Vector2(14,6),Vector2(14,5),Vector2(14,4),Vector2(13,4),Vector2(12,4),Vector2(11,4)]
var map1WinPosition : Vector2 = Vector2(17,7)
var map1ItemPosition = [Vector2(14,4),Vector2(14,9)]

#Global variable
var currentMapID = 1


#Preload
onready var itemPreload = preload("res://Scene/foodItems.tscn")

#32x+16,32y+16

func _ready():
	createItemsOnMap(1)
	pass # Replace with function body.


func createItemsOnMap(mapID):
	if(mapID == 1):
		for data in map1ItemPosition:
			var foodItem = itemPreload.instance()
			get_tree().current_scene.get_node("foodItems").call_deferred("add_child",foodItem)
			foodItem.call_deferred("_CreateObject",data,0)
		
