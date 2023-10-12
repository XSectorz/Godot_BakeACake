extends Node2D

onready var playerNode = get_node("/root/gameScene/player/playerBody")
onready var tileMapNode = get_node("/root/gameScene/TileMap")
onready var itemGuideList = [get_node("itemGuide/itemGuide1/itemGuideText"),
							get_node("itemGuide/itemGuide2/itemGuideText"),
							get_node("itemGuide/itemGuide3/itemGuideText"),
							get_node("itemGuide/itemGuide4/itemGuideText")]

onready var nextRoundUI = get_node("nextroundUI")
onready var gameOverUI = get_node("gameOverUI")
onready var timeoutBar = get_node("progressBar/timeLeftBar")
onready var infoLabel = get_node("itemGuide/INFO")
onready var infoTimer = get_node("timer/infoTimer")
onready var itemNode = get_node("/root/gameScene/foodItems")
onready var inputScript = get_node("/root/gameScene/Input")
onready var playerItems = get_node("/root/gameScene/playerItems")
onready var enemyLists = get_node("/root/gameScene/enemyLists")
onready var winPos = get_node("/root/gameScene/winPos")
onready var gameSceneNode = get_node("/root/gameScene")

var MAX_TIME_OUT = 3

var attemps = 0
var stringAnswer = ""
var itemAmount = [0,0,0,0]
var isPass = false
var tempcurrentMapItemList = []
var tween

func _ready():
	#var playerNode = get_tree().current_scene.get_node("/root/gameScene/player/playerBody")
	
	inputScript.connect("checkAnswer",self,"_checkAnswerInput")
	playerNode.connect("warpToKitchen",self,"_warpKitChen")
	nextRoundUI.connect("hideKitchen",self,"_changeToGameMode0")
	gameOverUI.connect("resetGameData",self,"_resetAllData")
	hide()
	#_warpKitChen()

func _resetAllData():
	self.hide()
	inputScript.hide()
	playerItems.hide()
	
	playerGlobal.gameModeType = 0
	playerGlobal.pScore = 0
	playerGlobal.items = [0,0,0,0]
	playerGlobal.isPlayerAlreadyInput = false
	playerGlobal.isPlayerFinish = false
	mapArray.currentMapItemList.clear()
	
	for i in range(0,4):
		var UIText = get_tree().current_scene.get_node("playerItems/UI/BackgroundItem" + str(i) + "/ItemLabel")
		UIText.text = str(0)
	
	#print("Reset Data and go to backmenu")

func _changeToGameMode0():
	
	self.hide()
	itemNode.show()
	playerNode.show()
	tileMapNode.show()
	enemyLists.show()
	winPos.show()
	playerGlobal.gameModeType = 0
	playerGlobal.isPlayerFinish = false
	playerGlobal.isPlayerAlreadyInput = false
	mapArray.currentMapItemList.clear()
	mapArray.currentMapID = 2
	mapArray.createItemsOnMap()
	mapArray.spawnEnemy()
	mapArray.spawnChest()
	gameSceneNode._randPlayerSpawn()
	
	
func _warpKitChen():
	#print("WARP!!")
	playerGlobal.gameModeType = 1
	#get_tree().change_scene("res://Scene/bakeACake.tscn")
	
	playerNode.hide()
	tileMapNode.hide()
	enemyLists.hide()
	winPos.hide()
	attemps = 0
	resetData()
	_hideElements()
	show()
	
func _hideElements():
	
	for item in itemNode.get_children():
		item.queue_free()
	
	itemNode.hide()
	nextRoundUI.hide()
	
func _createTimeoutBar():
	tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(
		timeoutBar, "value", 15, 0, 15,
		Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	tween.start()	
	tween.connect("tween_completed", self, "_on_tween_completed")

func _checkAnswerInput(data):
	
	if(tween != null):
		tween.stop(self)
		tween.queue_free()
	infoTimer.stop()
	
	
	if(data.to_upper() == stringAnswer):
		var isMatchReq = true
		for index in range(0,4):
			if(playerGlobal.items[index] < itemAmount[index]):
				infoLabel.text = "ITEMS NOT ENOUGH!"
				infoTimer.start()
				isMatchReq = false
				break
		if(isMatchReq):
			isPass = true
			for i in range(0,4):
				var nodeItemLabel = get_node("/root/gameScene/playerItems/UI/BackgroundItem" + str(i) + "/ItemLabel")
				nodeItemLabel.text = str(playerGlobal.items[i] - itemAmount[i])
			#print("Pass")
			
			var scoreLabel = nextRoundUI.get_node("UI/textLabel2")
			_addScore()
			mapArray.currentMapID = 2
			
			scoreLabel.text = str(playerGlobal.pScore)
			nextRoundUI.show()
			mapArray.nodeCollectSound.play()
			return
	else:
		infoLabel.text = "RECEIPTS WRONG!"
		
	infoTimer.start()
	timeOut()

func _addScore():
	var score = 100 - (attemps*25)
	playerGlobal.pScore += score

func _randomReciept():
	var random = RandomNumberGenerator.new()
	random.randomize()
	
	var baseAmount = mapArray.mapItemSize[mapArray.currentMapID-1]
	var amountReceipt = random.randi_range(baseAmount/2, baseAmount)
	
	#print("Base Amount : " + str(baseAmount))
	#print("Rand Amount : " + str(amountReceipt))
	
	tempcurrentMapItemList = mapArray.currentMapItemList.duplicate(true)
	#for data in tempcurrentMapItemList:
	#	print("items:" + str(data))
	#print("-------------------------")
	
	#print(str(itemAmount))
	
	for i in range(0,4):
		var string = ""
		
		var strSize = random.randi_range(1, 5)
		
		for j in range(0,strSize):
			var index = random.randi_range(0, 25)
			string += itemsImage.stringFormat[index]
			#print("Index : " + str(index) + " --> " + itemsImage.stringFormat[index])
			
		#print(str(i) + " RAND TEXT: " + string)
		itemGuideList[i].text = string
		
	for i in range(0,amountReceipt):
		var n = random.randi_range(0, 3)
		var nodeSlot = get_node("itemRegex/item"+ str(i+1) +"BG/itemTexture")
		
		var randItem = random.randi_range(0,tempcurrentMapItemList.size()-1)
		
		#print("Rand Item Show: " + str(mapArray.currentMapItemList[randItem]))
		
		itemAmount[tempcurrentMapItemList[randItem]] += 1;
		
		nodeSlot.texture = itemsImage.imgItemData[tempcurrentMapItemList[randItem]]
		stringAnswer += itemGuideList[tempcurrentMapItemList[randItem]].text
		tempcurrentMapItemList.remove(randItem)
	
		#print(str(n))
	print("Ans: " + stringAnswer)

func resetData():
	stringAnswer = ""
	itemAmount = [0,0,0,0]
	for i in range(0,6):
		var nodeSlot = get_node("itemRegex/item"+ str(i+1) +"BG/itemTexture")
		nodeSlot.texture = ImageTexture.new()
	_createTimeoutBar()
	_randomReciept()

func _gameOver():
	#print("GAME OVER!")
	mapArray.nodeGameoverSound.play()
	gameOverUI.show()
	var scoreLabel = gameOverUI.get_node("UI/textLabel2")
	scoreLabel.text = str(playerGlobal.pScore)

func timeOut():
	attemps += 1
	
	if(attemps == MAX_TIME_OUT):
		_gameOver()
	else:
		resetData()
	print("Attemps: " + str(attemps))
	
func _on_tween_completed(object, key):
	#time out!
	#print("END!")
	if(!isPass):
		infoLabel.text = "TIME OUT!"
		infoTimer.start()
		timeOut()


func _on_infoTimer_timeout():
	infoLabel.text = ""
