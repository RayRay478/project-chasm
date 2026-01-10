extends CharacterBody3D


@export_group("Movement")
@export var move_speed := 8.0
@export var acceleration := 20.0
@export var rotation_speed := 12.0
@export var jump_impulse := 12.0

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25
@export var tilt_upper_limit := PI / 3.0
@export var tilt_lower_limit := -PI / 8.0

var _camera_input_direction := Vector2.ZERO
var _last_movement_direction := Vector3.BACK
var _gravity := -30.0

@export var gravity_normal: Vector3 = Vector3.UP 

var slope_normal: Vector3 = Vector3.UP:
	set(new_normal):
		slope_normal = new_normal
		slope_mag_dot = slope_normal.dot(gravity_normal)
var slope_mag_dot:float

@onready var _camera: Camera3D = $Camera/CameraPivot/SpringArm3D/Camera3D
@onready var _body: Node3D = $Pivot/SONICGOOD

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE



func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensitivity


func _physics_process(delta: float) -> void:

	_camera_input_direction = Vector2.ZERO

	var axis: Vector3 = gravity_normal.cross(slope_normal).normalized()

	var raw_input := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var forward := _camera.global_basis.z
	var right := _camera.global_basis.x
	var move_direction := forward * raw_input.y + right * raw_input.x 
	move_direction.y = 0.0
	move_direction = move_direction.normalized()

	var y_velocity := velocity.y
	velocity.y = 0.0
	velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)
	velocity.y = y_velocity + _gravity * delta

	var is_starting_jump := Input.is_action_just_pressed("jump") and is_on_floor()
	if is_starting_jump:
		velocity.y += jump_impulse

	move_and_slide()

	if move_direction.length() > 0.2:
		_last_movement_direction = move_direction
	var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	_body.global_rotation.y = lerp_angle(_body.rotation.y, target_angle, rotation_speed * delta)

	_body.animate(velocity)
