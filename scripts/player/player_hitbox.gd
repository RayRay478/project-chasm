extends Area3D
class_name Hitbox

@export var player_health: Health

func take_damage(damage: int):
	player_health.health -= damage
