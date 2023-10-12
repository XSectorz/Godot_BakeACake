extends Node2D

# Instance Node
onready var Clound_1 = $Clound_1
onready var Clound_2 = $Clound_2
onready var Cake_1 = $Cake_1
onready var Cake_2 = $Cake_2
#onready var WaterReflex = $Water_Reflex

func _ready():
	#WaterReflex.play("WATER_REFLEX")
	pass

func _reset_Cakeposition():
	Cake_1.position.x = 0
	Cake_2.position.x = 0

func _reset_position():
	Clound_2.position.x = 0
	Clound_1.position.x = 0
	

func _physics_process(_delta):
	Clound_1.position.x -= 0.2
	Clound_2.position.x -= 0.2
	Cake_1.position.x -= 2
	Cake_2.position.x -= 2
	
	#print(str(Cake_2.position.x))
	
	if Clound_2.position.x <= -2356:
		_reset_position()
	if Cake_2.position.x <= -2054:
		_reset_Cakeposition()

