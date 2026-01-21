extends Node3D
class_name Body


const LERP_VELOCITY: float = 0.15


@onready var player = get_node_or_null("../..") # change path to your actual player path

@export var target_name: String = "Player"

@export_category("Objects")
@export var _character: CharacterBody3D = null
@export var animation_player: AnimationPlayer = null

func apply_rotation(_velocity: Vector3) -> void:
	var new_rotation_y = lerp_angle(rotation.y, atan2(-_velocity.x, -_velocity.z), LERP_VELOCITY)
	rotation.y = new_rotation_y


func animate(_velocity: Vector3) -> void:

	if not _character.is_on_floor():
		if _velocity.y < 0:
			animation_player.play("Air")
		else:
			var current_anim = animation_player.current_animation
			if current_anim != "Jump" and current_anim != "Jump":
				animation_player.play("Jump")
		return
		
	else: 
		animation_player.play("Idle ")


func play_jump_animation(jump_type: String = "Jump") -> void:
	if animation_player:
		animation_player.play(jump_type)
