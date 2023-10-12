extends Node2D

onready var nodeMainMenu = get_node("mainMenu")
onready var nodePlayer = get_node("player/playerBody")
onready var nodeTileMap = get_node("TileMap")
onready var nodeInput = get_node("Input")
onready var nodeFoodItems = get_node("foodItems")
onready var nodePlayerItems = get_node("playerItems")
onready var nodeEnemyLists = get_node("enemyLists")
onready var nodeWinPos = get_node("/root/gameScene/winPos")


func _ready():
	nodeMainMenu.connect("gameStart",self,"_startGame")
	nodePlayer.hide()
	
func _randPlayerSpawn():
	
	var random = RandomNumberGenerator.new()
	random.randomize()
	var indexRand = random.randi_range(0, mapArray.pSpawnPosition.size()-1)
	nodePlayer.spawnPlayer(mapArray.pSpawnPosition[indexRand])
	nodeInput.get_node("inputDecoration/inputBox").grab_focus()
	
	#print("RAND: " + str(mapArray.pSpawnPosition[indexRand]))

func _startGame():
	print("Start!")
	
	nodePlayer.show()
	nodeTileMap.show()
	nodeInput.show()
	nodeFoodItems.show()
	nodePlayerItems.show()
	nodeEnemyLists.show()
	nodeWinPos.show()
	nodeMainMenu.hide()
	playerGlobal.isPlayerFinish = false
	playerGlobal.isPlayerAlreadyInput = false
	mapArray.currentMapItemList.clear()
	
	mapArray.currentMapID = 1
	mapArray.createItemsOnMap()
	mapArray.spawnEnemy()
	mapArray.spawnChest()
	_randPlayerSpawn()
	

