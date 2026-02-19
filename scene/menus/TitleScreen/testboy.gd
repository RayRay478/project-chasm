extends Node
var tween: Tween
@export var animation_player = ConductedAnimationPlayer.new()
# Assign this variable to MPAuth node

func _ready():

	Conductor.set_song(load ("res://audio/01 - Title Screen.mp3"), 144)
	Conductor.play()
	
	

func on_beat() -> void:
	reset()
	animation_player.play("bonuce")
	print("is this working")

func _on_conducted_timer_timeout() -> void:
	on_beat() # Replace with function body.

func reset() -> void:
	animation_player.stop()
	if tween and tween.is_running():
		tween.kill()
