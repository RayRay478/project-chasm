extends RigidBody3D

class_name GravityProjectile

@export var speed: int
@export var hurtbox: Hurtbox
@export var ray: RayCast3D
@export var timer: Timer

var old_speed: int
const stop = 0





func _process(delta):
	old_speed = speed
	apply_torque_impulse(Vector3.MODEL_FRONT)

	gravity_scale = -2


		
func _stop():
		speed = stop
		hurtbox.monitoring = false
		hide()



	
