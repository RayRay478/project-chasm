@icon("res://textures/icons/codingspecialstuff/health.png")

extends Node3D
class_name Health

@export var max_health := 10.0
var health : float 

func _ready():
	health = max_health
	
func take_damage(damage: int):
	if health:
		health -= damage
