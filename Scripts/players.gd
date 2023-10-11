extends KinematicBody2D



onready var moveTimer = get_node("Timer")
onready var tileMapNode = get_node("/root/")

#var moveArray = ['D','D','D','W','W','S','S','A','A','D','D','S','S','D','D']
var moveArray = ['D','D','D','D','W','W','S','A','A','S','S','S','A','A']
var currentMoveIndex = 0;

var velocity : Vector2 = Vector2()
var speed = 100
var moveEnd = false
var isStartMove = false
var currentPosition = position
var targetPosition : Vector2 = Vector2()

#Signal
signal warpToKitchen

# Called when the node enters the scene tree for the first time.
func _ready():
	moveTimer.start()
	position.x = 176
	position.y = 176
	targetPosition.x = 176
	targetPosition.y = 176
	
	#print(get_path())
	
	var inputScript = get_node("/root/gameScene/Input")
	
	#Connect Signal
	inputScript.connect("playerConfirmMove",self,"startMoveSignal")
	
	#print(mapArray.map1Index)


func _physics_process(delta):
	velocity.x = 0
	
	
	#print(position.x)
	#print(position.y)
	#print("-----------")
	var isDoneMove = false
	if(isStartMove && playerGlobal.gameModeType == 0):
		if(moveTimer.is_stopped()):
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
					
					if(position.x ==  (mapArray.map1WinPosition.x*32)+16 && position.y ==  (mapArray.map1WinPosition.y*32)+16):
						print("WIN")
						emit_signal("warpToKitchen")
					else:
						for itemFood in get_tree().current_scene.get_node("foodItems").get_children():
							if(position.x == itemFood.position.x && position.y ==  itemFood.position.y):
								print("GET! ITEM: " + str(itemFood.foodType) + " Pos: " + str(itemFood.position))
								playerGlobal.items[itemFood.foodType] += 1
								
								var UIText = get_tree().current_scene.get_node("playerItems/UI/BackgroundItem" + str(itemFood.foodType) + "/ItemLabel")
								UIText.text = str(playerGlobal.items[itemFood.foodType])
								
								
								itemFood.queue_free()
								break
					
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
	if(currentMoveIndex == moveArray.size()):
		#print("END MOVEMENT");
		return
	else:
		#print(moveArray[currentMoveIndex])
		
		var tempPos : Vector2 = position
		
		if(moveArray[currentMoveIndex] == 'D' || moveArray[currentMoveIndex] == 'd'):
			 tempPos.x = tempPos.x + 32
		elif(moveArray[currentMoveIndex] == 'A' || moveArray[currentMoveIndex] == 'a'):
			 tempPos.x = tempPos.x - 32
		elif(moveArray[currentMoveIndex] == 'W' || moveArray[currentMoveIndex] == 'w'):
			 tempPos.y = tempPos.y - 32
		elif(moveArray[currentMoveIndex] == 'S' || moveArray[currentMoveIndex] == 's'):
			 tempPos.y = tempPos.y + 32
		
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
