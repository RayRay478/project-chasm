extends Node3D

class_name Body

const LERP_VELOCITY: float = 0.15
# @onready var player = get_node("../../../../../..")
# changes path to your actual player path (changed all the @onready $Something with exports; 
#less hardcoding paths, faster to debug + safer - h)
@export var player: CharacterBody3D
@export var character: CharacterBody3D
@export var animation_player: AnimationPlayer

@export var target_name: String = "Player"

@export_category("Objects")

func apply_rotation(_velocity: Vector3) -> void:
	var new_rotation_y = lerp_angle(rotation.y, atan2(-_velocity.x, -_velocity.z), LERP_VELOCITY)
	rotation.y = new_rotation_y


func animate(_velocity: Vector3) -> void:
	if character == null or animation_player == null:
		return

	var want: String

	# AIR
	if not character.is_on_floor():
		want = "Air" if _velocity.y < 0.0 else "Jump"
	else:
		# GROUND SPEED (horizontal only)
		var speed := character.velocity.slide(character.up_direction).length()

		if speed < 0.1:
			want = "Idle "      # (NOTE: there's a space after Idle in the AnimPlayer - h)
		elif speed < 18.0:
			want = "Walk"
		else:
			want = "Run"

	# Play only if changed or finished
	if animation_player.current_animation != want or not animation_player.is_playing():
		animation_player.play(want)


	# OLD GROUNDED ANIM CODE (just for safekeeping?) - h
	# if player == null or animation_player == null:
	#	return

	# if not player.is_on_floor():
	#	if _velocity.y < 0:
	#		animation_player.play("Air")
	#	else:
	#		animation_player.play("Jump")
	#	return

	# animation_player.play("Idle ")


	# OLD GROUNDED ANIM CODE (just for safekeeping?) - h
	# if player.accel_speed >= 0.5:
	#	animation_player.play("Run")
#	else:
#		animation_player.play("Idle ")




func play_jump_animation(jump_type: String = "Jump") -> void:
	if animation_player:
		animation_player.play(jump_type)
