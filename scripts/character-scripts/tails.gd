@icon("res://ui/UI/HP CHARACTERS/tails1.png")
extends PlayerMain

var flying_state: bool = false
var flying_power = 10
var jumps: int = 0
const total_jump: int = 2

func _physics_process(_delta: float) -> void:
	super(_delta)

	if jumps > 0 and jump_state:
		if Input.is_action_just_pressed("jump"):
			jumps -= 1
	if jumps == 0:
		flying_state = true
		jump_state = false
	
	if flying_state:
		_gravity = move_toward(-15, -30, 0.1)
		if Input.is_action_just_pressed("jump"):
			velocity += up_direction * flying_power
		
	
	if is_on_floor():
		_gravity = -40
		jumps = total_jump
		flying_state = false
