extends Node2D
class_name Selector
@export var button_group : ButtonGroup

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_accept"):
		#which_pressed()

func which_pressed():
	var button_pressed = button_group.get_pressed_button()
	match button_pressed.name:
		"Sonic":
			Global.characterID = 0
			print("sonic")
		"Tails":
			Global.characterID = 1
			print("tails")
		"Knuckles":
			Global.characterID = 2
			print("knuckles")
