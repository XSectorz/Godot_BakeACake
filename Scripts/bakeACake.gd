extends Node2D

onready var playerNode = get_node("/root/gameScene/player/playerBody")
onready var itemGuideList = [get_node("itemGuide/itemGuide1/itemGuideText"),
							get_node("itemGuide/itemGuide2/itemGuideText"),
							get_node("itemGuide/itemGuide3/itemGuideText"),
							get_node("itemGuide/itemGuide4/itemGuideText")]

var stringAnswer = ""

func _ready():
	#var playerNode = get_tree().current_scene.get_node("/root/gameScene/player/playerBody")
	
	playerNode.connect("warpToKitchen",self,"_warpKitChen")
	hide()
	_warpKitChen()

func _warpKitChen():
	#print("WARP!!")
	playerGlobal.gameModeType = 1
	#get_tree().change_scene("res://Scene/bakeACake.tscn")
	var inputScript = get_node("/root/gameScene/Input")
	inputScript.connect("checkAnswer",self,"_checkAnswerInput")
	
	playerNode.hide()
	_hideElements()
	_randomReciept()
	show()
	
func _hideElements():
	var itemNode = get_node("/root/gameScene/foodItems")
	
	for item in itemNode.get_children():
		item.queue_free()
	
	itemNode.hide()
	
func _checkAnswerInput(data):
	
	if(data == stringAnswer):
		print("NEXT!")
	else:
		print("LOSS!")

func _randomReciept():
	var random = RandomNumberGenerator.new()
	random.randomize()
	
	var baseAmount = mapArray.mapItemSize[mapArray.currentMapID-1]
	var amountReceipt = random.randi_range(baseAmount/2, baseAmount)
	
	print("Base Amount : " + str(baseAmount))
	print("Rand Amount : " + str(amountReceipt))
	
	for i in range(0,4):
		var string = ""
		
		var strSize = random.randi_range(1, 5)
		
		for j in range(1,strSize):
			var index = random.randi_range(0, 25)
			string += itemsImage.stringFormat[index]
			
		print(str(i) + " RAND TEXT: " + string)
		itemGuideList[i].text = string
		
	for i in range(0,amountReceipt):
		var n = random.randi_range(0, 3)
		var nodeSlot = get_node("itemRegex/item"+ str(i+1) +"BG/itemTexture")
		
		var randItem = random.randi_range(0, mapArray.currentMapItemList.size()-1)
		
		print("Rand Item Show: " + str(mapArray.currentMapItemList[randItem]))
		
		nodeSlot.texture = itemsImage.imgItemData[mapArray.currentMapItemList[randItem]]
		stringAnswer += itemGuideList[mapArray.currentMapItemList[randItem]].text
		mapArray.currentMapItemList.remove(randItem)
	
		#print(str(n))
	print("Ans: " + stringAnswer)
