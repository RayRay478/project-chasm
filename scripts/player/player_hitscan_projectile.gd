extends Node3D

class_name HitscanProjectile

var speed: int
@export var pure_speed: int
const stop = 0
@export var hurtbox: Hurtbox
@export var ray: RayCast3D
@export var timer: Timer
@export var spawn_location : Node3D

func _ready() -> void:
	_off()

func _process(delta):
	position += transform.basis * Vector3(0, 0, speed) * delta
#	position += spawn_location.global_position
#	global_transform.basis = spawn_location.global_transform.basis
#	global_position = spawn_location.global_position

	if ray.is_colliding():
		_off()
	#if timer.timeout:
	#	timer.stop()
	#	_off()

func _on():
	print("fuckon")
	speed = pure_speed
	hurtbox.monitoring = true
	#timer.start(2)
	ray.enabled = true
	show()

func _off():
	print("fuckoff")
	ray.enabled = false
	speed = stop
	#timer.stop()
	hurtbox.monitoring = false
	hide()



	
