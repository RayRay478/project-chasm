extends Button

var character = preload("res://entity/characternew.tscn")

func _on_pressed() -> void:
	var player = character.instantiate()
	get_tree().get_root().get_node("Node3D").add_child(player)
	$"..".hide()
