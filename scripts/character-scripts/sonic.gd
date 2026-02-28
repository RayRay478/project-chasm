extends PlayerMain

func _physics_process(_delta: float) -> void:
	if action1_state:
		print("NIGGA PLEASE WORK")
		velocity = velocity.slide(up_direction).move_toward(Vector3.ZERO, 10)
