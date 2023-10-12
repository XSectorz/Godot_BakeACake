extends KinematicBody2D



onready var moveTimer = get_node("Timer")
onready var gameoverUI = get_node("/root/gameScene/gameOverUI")
onready var inputScript = get_node("/root/gameScene/Input")
onready var playerItems = get_node("/root/gameScene/playerItems")
onready var nodeTileMap = get_node("/root/gameScene/TileMap")

#var moveArray = ['D','D','D','W','W','S','S','A','A','D','D','S','S','D','D']
var moveArray = ['D','D','D','D','W','W','S','A','A','S','S','S','A','A']
var currentMoveIndex = 0;

var velocity : Vector2 = Vector2()
var speed = 100
var moveEnd = false
var isStartMove = false
var currentPosition = position
var targetPosition : Vector2 = Vector2()

onready var playerAnimated = get_node("playerAnimated")

#Signal
signal warpToKitchen

# Called when the node enters the scene tree for the first time.
func _ready():
	moveTimer.start()
	
	#print(get_path())
	
	#Connect Signal
	inputScript.connect("playerConfirmMove",self,"startMoveSignal")
	gameoverUI.connect("resetGameData",self,"_resetAllData")
	
	#print(mapArray.map1Index)

func _resetAllData():
	
	for item in get_tree().current_scene.get_node("foodItems").get_children():
		item.queue_free()
	for enemy in get_tree().current_scene.get_node("enemyLists").get_children():
		enemy.queue_free()
	for chest in get_tree().current_scene.get_node("winPos").get_children():
		chest.queue_free()
	self.hide()
	inputScript.hide()
	playerItems.hide()
	nodeTileMap.hide()
	
	playerAnimated.play("MOVE_BACKWARD")
	playerGlobal.gameModeType = 0
	playerGlobal.pScore = 0
	playerGlobal.items = [0,0,0,0]
	playerGlobal.isPlayerAlreadyInput = false
	mapArray.currentMapItemList.clear()
	
	for i in range(0,4):
		var UIText = get_tree().current_scene.get_node("playerItems/UI/BackgroundItem" + str(i) + "/ItemLabel")
		UIText.text = str(0)

func spawnPlayer(loc):
	position.x = (loc.x*32)+16
	position.y = (loc.y*32)+16
	targetPosition.x = (loc.x*32)+16
	targetPosition.y = (loc.y*32)+16

func _physics_process(delta):
	velocity.x = 0
	
	
	#print(position.x)
	#print(position.y)
	#print("-----------")
	var isDoneMove = false
	if(isStartMove && playerGlobal.gameModeType == 0):
		if(moveTimer.is_stopped()):
			#print("P: " + str(position.x) + "|" + str(position.y) + " TARGET: " + str(targetPosition.x) + "|" + str(targetPosition.y))
			if(position.x == targetPosition.x && position.y == targetPosition.y):
				moveLogic()
			else:
				#print(moveArray[currentMoveIndex])
				if(moveArray[currentMoveIndex] == 'D' || moveArray[currentMoveIndex] == 'd'):
					if(position.x < targetPosition.x):
						move_and_slide(Vector2(64,0), Vector2(0,-1))
					else:
						isDoneMove = true
				elif(moveArray[currentMoveIndex] == 'A' || moveArray[currentMoveIndex] == 'a'):
					if(position.x > targetPosition.x):
						move_and_slide(Vector2(-64,0), Vector2(0,-1))
					else:
						isDoneMove = true
				elif(moveArray[currentMoveIndex] == 'W' || moveArray[currentMoveIndex] == 'w'):
					if(position.y > targetPosition.y):
						move_and_slide(Vector2(0,-64), Vector2(0,-1))
					else:
						isDoneMove = true
				elif(moveArray[currentMoveIndex] == 'S' || moveArray[currentMoveIndex] == 's'):
					if(position.y < targetPosition.y):
						move_and_slide(Vector2(0,64), Vector2(0,-1))
					else:
						isDoneMove = true
				
				if(isDoneMove):
					position.x = targetPosition.x
					position.y = targetPosition.y
					currentMoveIndex += 1
					moveTimer.start()
					
					for winPosition in get_tree().current_scene.get_node("winPos").get_children():
						if(position.x ==  winPosition.position.x && position.y ==  winPosition.position.y):
							#print("WIN")
							playerGlobal.isPlayerFinish = true
							isStartMove = false
							inputScript.get_node("startNode/exampleText").text = "INPUT HERE"
							moveArray = []
							emit_signal("warpToKitchen")
						else:
							for itemFood in get_tree().current_scene.get_node("foodItems").get_children():
								if(position.x == itemFood.position.x && position.y ==  itemFood.position.y):
									#print("GET! ITEM: " + str(itemFood.foodType) + " Pos: " + str(itemFood.position))
									playerGlobal.items[itemFood.foodType] += 1
									
									var UIText = get_tree().current_scene.get_node("playerItems/UI/BackgroundItem" + str(itemFood.foodType) + "/ItemLabel")
									UIText.text = str(playerGlobal.items[itemFood.foodType])
									
									mapArray.nodeCollectSound.play()
									itemFood.queue_free()
									break
							for enemy in get_tree().current_scene.get_node("enemyLists").get_children():
								if(position.x == enemy.position.x && position.y ==  enemy.position.y):
									#print("LOSS Trap State!")
									gameoverUI.show()
									var scoreLabel = gameoverUI.get_node("UI/textLabel2")
									scoreLabel.text = str(playerGlobal.pScore)
									isStartMove = false
									mapArray.nodeGameoverSound.play()
									return
					
					#print("MOVE END AT X : " + str(position.x) + " TargetPos: " + str(targetPosition.x))
					#print("MOVE END AT Y : " + str(position.y) + " TargetPos: " + str(targetPosition.y))
	
	#for move in moveArray:
	#	print(move);
	#print("-------------------");

func startMoveSignal(data):
	#print("StartMove: " + data)
	moveArray.clear()
	currentMoveIndex = 0
	
	for move in data:
		moveArray.append(move)
	
	isStartMove = true

func moveLogic():
	#print("CURR : " + str(currentMoveIndex) + " SIZE: " + str(moveArray.size()))
	if(currentMoveIndex == moveArray.size()):
		#print("END MOVEMENT " + str(playerGlobal.isPlayerFinish));
		if(!playerGlobal.isPlayerFinish):
			gameoverUI.show()
			var scoreLabel = gameoverUI.get_node("UI/textLabel2")
			scoreLabel.text = str(playerGlobal.pScore)
			isStartMove = false
			mapArray.nodeGameoverSound.play()
			#print("LOSE")
			return
	else:
		#print(moveArray[currentMoveIndex])
		
		var tempPos : Vector2 = position
		
		if(moveArray[currentMoveIndex] == 'D' || moveArray[currentMoveIndex] == 'd'):
			tempPos.x = tempPos.x + 32
			playerAnimated.play("MOVE_RIGHT")
		elif(moveArray[currentMoveIndex] == 'A' || moveArray[currentMoveIndex] == 'a'):
			tempPos.x = tempPos.x - 32
			playerAnimated.play("MOVE_LEFT")
		elif(moveArray[currentMoveIndex] == 'W' || moveArray[currentMoveIndex] == 'w'):
			tempPos.y = tempPos.y - 32
			playerAnimated.play("MOVE_FORWARD")
		elif(moveArray[currentMoveIndex] == 'S' || moveArray[currentMoveIndex] == 's'):
			tempPos.y = tempPos.y + 32
			playerAnimated.play("MOVE_BACKWARD")
		
		var isCanMove = false
		for data in mapArray.map1VectorData:
			if(tempPos.x == (data.x*32)+16 && tempPos.y == (data.y*32)+16):
				isCanMove = true
				break
		#print("--------------------------")
		if(isCanMove):
			#print("Contain CanMove : " + str(tempPos.x) + " | " + str(tempPos.y))
			targetPosition.x = tempPos.x
			targetPosition.y = tempPos.y
		else:
			#print("Not Contain Cant Move : " + moveArray[currentMoveIndex])
			currentMoveIndex += 1
