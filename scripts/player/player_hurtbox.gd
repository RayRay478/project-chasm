extends Area3D

class_name Hurtbox

@export var damage: int

func _ready() -> void:
	monitoring = true
	
	area_entered.connect(_on_area_entered)
	
func _on_area_entered(area: Area3D):
	print("fucking ow???")
	if area.has_method("take_damage"): 
		area.take_damage(damage)
