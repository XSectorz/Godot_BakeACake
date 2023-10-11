extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var inputBox = get_node("inputDecoration/inputBox")
onready var exampleText = get_node("startNode/exampleText")
var prevtextLength = 0;

signal playerConfirmMove(data)
signal checkAnswer(data)

# Called when the node enters the scene tree for the first time.
func _ready():
	inputBox.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_inputBox_text_changed(new_text):
	#print(get_path())
	#print(new_text)
	var textLength = new_text.length()
	#print(textLength)
	
	if(prevtextLength > textLength):
		prevtextLength = textLength
	else:
		if(new_text[textLength-1] != 'A' && new_text[textLength-1] != 'a'
			&& new_text[textLength-1] != 'W' && new_text[textLength-1] != 'w'
			&& new_text[textLength-1] != 'S' && new_text[textLength-1] != 's'
			&& new_text[textLength-1] != 'D' && new_text[textLength-1] != 'd'):
			if(playerGlobal.gameModeType == 0):
				if(new_text.length() > 1):
					inputBox.set_text(new_text.substr(0, textLength - 1))
					inputBox.set_cursor_position(inputBox.text.length())
					prevtextLength = inputBox.text.length()
				else:
					inputBox.set_text("")
			else:
				prevtextLength = inputBox.text.length()
		else:
			prevtextLength = inputBox.text.length()
		
	#print("PREV: " + str(prevtextLength) + " CUR " + str(textLength))
	if(prevtextLength > 0):
		exampleText.hide()
	else:
		exampleText.show()

func _on_inputBox_text_entered(new_text):
	print("Entered")
	if(playerGlobal.gameModeType == 0):
		emit_signal("playerConfirmMove",inputBox.text)
	else:
		print("COME")
		emit_signal("checkAnswer",inputBox.text)
	inputBox.set_text("")
	exampleText.show()
