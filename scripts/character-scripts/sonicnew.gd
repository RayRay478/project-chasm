@icon("res://ui/UI/HP CHARACTERS/sonic1.png")

extends PlayerMain

@export_category("Character Specifics")

@export var sonic_wind : HitscanProjectile
@onready var animation: Body
@export var wind_location : Node3D




func _physics_process(_delta: float) -> void:
	super(_delta)
	
	if action1_state:
		print("workin?")
		sonic_wind._on()
		body.global_rotation.y = wind_location.global_rotation.y
		sonic_wind.position = wind_location.global_position
		sonic_wind.global_transform.basis = wind_location.global_transform.basis
		sonic_wind.global_position = wind_location.global_position
	
