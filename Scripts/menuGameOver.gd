extends Node2D

onready var nodeMainMenu = get_node("/root/gameScene/mainMenu")
onready var nodeInfo = get_node("/root/gameScene/GameInfo")
signal resetGameData

func _ready():
	pass


func _on_nextButton_pressed():
	nodeMainMenu.show()
	nodeInfo.show()
	hide()
	emit_signal("resetGameData")
