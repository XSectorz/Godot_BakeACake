extends Node2D

onready var nodeMainMenu = get_node("/root/gameScene/mainMenu")
signal resetGameData

func _ready():
	pass


func _on_nextButton_pressed():
	nodeMainMenu.show()
	hide()
	emit_signal("resetGameData")
