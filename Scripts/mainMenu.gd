extends Node2D

signal gameStart


func _on_startGameButton_pressed():
	emit_signal("gameStart")
