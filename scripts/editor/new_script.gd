@tool
extends Node

func _init() -> void:
	var coll = CollisionShape2D.new()
	add_child(coll)
	coll.owner = get_tree().edited_scene_root
