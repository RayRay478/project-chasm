@icon("res://textures/icons/codingspecialstuff/debug.png")

extends Node3D

class_name Debug

const debug_enabled: bool = true

@export var debug_label: Label
@export var player: PlayerMain
@export var health: Health

func readable_vector(input:Vector3) -> String:
	return str(input.snappedf(0.01))

func readable_float(input:float) -> String:
	return str(snappedf(input, 0.01))

func add_debug_info(info:String) -> void:
	if debug_enabled:
		debug_label.text += info + "\n"

func _physics_process(_delta: float) -> void:
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")

	var input_3 : Vector3 = Vector3(
	input_dir.x,
	0.0, 
	input_dir.y
	)
	
	debug_label.text = ""
	
	add_debug_info("Current Health: " + readable_float(health.health))
	add_debug_info("")
	add_debug_info("Input Vector: " + readable_vector(input_3))
	#add_debug_info("Driection: " + readable_vector(direction))
	add_debug_info("Velocity: " + readable_vector(player.velocity))
	add_debug_info("Speed Up?: " + readable_float(player.accel_speed))
	add_debug_info("Grounded?: " + readable_float(player.is_on_floor()))
	add_debug_info("Gravity: " + readable_float(player._gravity))
	add_debug_info("Jump Velo: " + readable_float(player.jump_gravity))
	add_debug_info("")
	add_debug_info("Character: " + readable_float(Global.characterID))
	add_debug_info("CharacterRN?: " + str(Global.player_char))
	add_debug_info("")
	add_debug_info("STATES")
	add_debug_info("Jumping: " + str(player.jump_state))
	add_debug_info("Action1: " + str(player.action1_state))
	add_debug_info("Action2: " + str(player.action2_state))
	add_debug_info("Action3: " + str(player.action3_state))
	
	add_debug_info("")
	add_debug_info("CHARACTER STATES")
	if Global.characterID == 1:
		add_debug_info("Flying?: " + str(player.flying_state))
		add_debug_info("Jumps: " + readable_float(player.jumps))
