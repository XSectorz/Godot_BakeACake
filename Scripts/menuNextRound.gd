extends Node2D

signal hideKitchen

func _ready():
	pass 


func _on_nextButton_pressed():
	hide()
	emit_signal("hideKitchen")
