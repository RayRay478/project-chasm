extends Node3D

class_name PlayerCamera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

@export var camera : Camera3D
@onready var _camera_pivot := $CameraPivot as Node3D # this is used for movement reference
@export var tilt_limit = deg_to_rad(75)

@export var character: CharacterBody3D

@export_range(0.0, 1.0) var mouse_sensitivity = 0.01



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_camera_pivot.rotation.x -= event.relative.y * mouse_sensitivity
		# Prevent the camera from rotating too far up or down.
		_camera_pivot.rotation.x = clampf(_camera_pivot.rotation.x, -tilt_limit, tilt_limit)
		_camera_pivot.rotation.y += -event.relative.x * mouse_sensitivity

	if character == null:
		return

	#var speed := character.velocity.slide(character.up_direction).length()

	#if speed < 0.1:
		#camera.set_fov(100.0)
	#elif speed < 18.0:
		#camera.set_fov(179.0)
