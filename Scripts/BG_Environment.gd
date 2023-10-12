extends Node2D

# Instance Node
onready var Clound_1 = $Clound_1
onready var Clound_2 = $Clound_2
#onready var WaterReflex = $Water_Reflex

func _ready():
	#WaterReflex.play("WATER_REFLEX")
	pass

func _reset_position():
	Clound_2.position.x = 0
	Clound_1.position.x = 0

func _physics_process(_delta):
	Clound_1.position.x -= 0.2
	Clound_2.position.x -= 0.2
	
	if Clound_2.position.x <= -2356:
		_reset_position()

