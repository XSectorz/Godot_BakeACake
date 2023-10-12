extends Node


#Map Position
#var map1Index = [Vector2(176,176),Vector2(208,176),Vector2(240,176),Vector2(272,176),Vector2(272,144),Vector2(272,112),Vector2(272,208),Vector2(272,240),Vector2(304,240),Vector2(336,240)]
var map1VectorData = [Vector2(5,5),Vector2(6,5),Vector2(7,5),Vector2(8,5),Vector2(8,4),Vector2(8,3),Vector2(8,6),Vector2(8,7),Vector2(9,7),Vector2(10,7)
					,Vector2(10,7),Vector2(11,7),Vector2(12,7),Vector2(13,7),Vector2(14,7),Vector2(15,7),Vector2(16,7),Vector2(17,7),Vector2(14,8),Vector2(14,9)
					,Vector2(14,6),Vector2(14,5),Vector2(14,4),Vector2(13,4),Vector2(12,4),Vector2(11,4),Vector2(4,5),Vector2(4,6),Vector2(4,7),Vector2(4,8),Vector2(4,9)
					,Vector2(4,10),Vector2(5,10),Vector2(6,10),Vector2(7,10),Vector2(8,10),Vector2(8,9),Vector2(8,8),Vector2(8,11),Vector2(8,12),Vector2(9,12),Vector2(10,12)
					,Vector2(11,12),Vector2(12,12),Vector2(13,12),Vector2(14,12),Vector2(14,11),Vector2(14,10),Vector2(15,10),Vector2(16,10),Vector2(17,10),Vector2(18,10),Vector2(19,10)
					,Vector2(20,10),Vector2(20,9),Vector2(21,9),Vector2(21,8),Vector2(21,8),Vector2(22,8),Vector2(23,8),Vector2(24,8),Vector2(24,9),Vector2(24,10),Vector2(24,11),Vector2(24,12)
					,Vector2(25,12),Vector2(26,12),Vector2(26,11),Vector2(26,10),Vector2(26,9),Vector2(25,9),Vector2(27,9),Vector2(27,8),Vector2(27,7),Vector2(27,6),Vector2(28,8),Vector2(26,6),Vector2(25,6)
					,Vector2(24,6),Vector2(26,5),Vector2(26,4),Vector2(25,4),Vector2(24,5),Vector2(24,4),Vector2(23,4),Vector2(22,4),Vector2(21,4),Vector2(20,4),Vector2(19,4)
					,Vector2(19,5),Vector2(19,6),Vector2(19,7),Vector2(18,7)]
var map1WinPosition : Vector2 = Vector2(17,7)

var pSpawnPosition = [Vector2(5,5),Vector2(25,4),Vector2(23,4),Vector2(27,7),Vector2(26,6),Vector2(9,7),Vector2(12,12),Vector2(8,4),Vector2(8,3),Vector2(10,7)]
#var pSpawnPosition = [Vector2(5,5)]

onready var nodeCollectSound = get_node("/root/gameScene/CollectSound")
onready var nodeGameoverSound = get_node("/root/gameScene/GameoverSound")

var mapItemTypeList = [[0,1,2],[0,1,2,3]]
var mapItemSize = [3,6]
var mapItemPos = [[Vector2(14,4),Vector2(14,8),Vector2(14,6),Vector2(19,7),Vector2(24,6),Vector2(12,7),Vector2(14,5),Vector2(11,7),Vector2(18,10),Vector2(24,11),Vector2(13,4)
				,Vector2(8,6),Vector2(10,7),Vector2(14,10),Vector2(12,12),Vector2(8,9),Vector2(22,4),Vector2(27,9),Vector2(26,11),Vector2(25,12),Vector2(24,12)
				,Vector2(15,10),Vector2(19,5),Vector2(19,7),Vector2(13,12),Vector2(23,8)]]
var currentMapItemList = []

var kitchenPos = [Vector2(8,3),Vector2(11,4),Vector2(28,8)]
#var kitchenPos = [Vector2(6,5)]
var enemyPos = [Vector2(4,6),Vector2(8,8),Vector2(14,9),Vector2(25,9),Vector2(26,5)]

#Global variable
var currentMapID = 1


#Preload
onready var itemPreload = preload("res://Scene/foodItems.tscn")
onready var enemyPreload = preload("res://Scene/enemyScene.tscn")
onready var toKitchenPreload = preload("res://Scene/toKitchen.tscn")

#32x+16,32y+16

func _ready():
	pass # Replace with function body.

func spawnEnemy():
	for enemy in get_tree().current_scene.get_node("enemyLists").get_children():
		enemy.queue_free()
	var random = RandomNumberGenerator.new()
	random.randomize()
	
	var indexEnemyPos = random.randi_range(0, enemyPos.size()-1)
		
	var enemy = enemyPreload.instance()
	get_tree().current_scene.get_node("enemyLists").call_deferred("add_child",enemy)
	enemy.call_deferred("_spawn",enemyPos[indexEnemyPos])
	
func spawnChest():
	for chest in get_tree().current_scene.get_node("winPos").get_children():
		chest.queue_free()
	var random = RandomNumberGenerator.new()
	random.randomize()
	
	var indexEnemyPos = random.randi_range(0, kitchenPos.size()-1)
		
	var chest = toKitchenPreload.instance()
	get_tree().current_scene.get_node("winPos").call_deferred("add_child",chest)
	chest.call_deferred("_spawn",kitchenPos[indexEnemyPos])

func createItemsOnMap():
	
	var posibleItemPos = mapItemPos.duplicate(true)
	
	#print("Size: " + str(posibleItemPos[0]))
	
	#print("ItemSize: " + str(posibleItemPos[0]))
	#print("MapItem: " + str(mapItemPos[0]))
	#print("-------------")

	for i in range(0,mapItemSize[currentMapID-1]):
		var random = RandomNumberGenerator.new()
		random.randomize()
		var indexItemPos = random.randi_range(0, posibleItemPos[0].size()-1)
		
		var n = random.randi_range(0, mapItemTypeList[currentMapID-1].size()-1)
		var foodItem = itemPreload.instance()
		get_tree().current_scene.get_node("foodItems").call_deferred("add_child",foodItem)
		foodItem.call_deferred("_CreateObject",posibleItemPos[0][indexItemPos],n)
		
		posibleItemPos[0].remove(indexItemPos)
		currentMapItemList.append(n)
		#print("SPAWN! " + str(indexItemPos))
	
	
	
	#for itemList in currentMapItemList:
	#	print("Item: " + str(itemList))
		
