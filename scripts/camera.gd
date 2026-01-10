extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

@onready var camera = $CameraPivot/SpringArm3D/Camera3D
@onready var _camera_pivot := $CameraPivot as Node3D # this is used for movement reference
@export var tilt_limit = deg_to_rad(75)


@export_range(0.0, 1.0) var mouse_sensitivity = 0.01

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_camera_pivot.rotation.x -= event.relative.y * mouse_sensitivity
		# Prevent the camera from rotating too far up or down.
		_camera_pivot.rotation.x = clampf(_camera_pivot.rotation.x, -tilt_limit, tilt_limit)
		_camera_pivot.rotation.y += -event.relative.x * mouse_sensitivity
