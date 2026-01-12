extends CharacterBody3D

const debug_enabled: bool = true

@export_group("Movement")
@export var move_speed := 20.0
@export var max_speed := 40.0

@export var acceleration := 20.0
@export var deceleration := 20.0
@export var rotation_speed := 12.0
@export var jump_impulse := 12.0

var last_player_input_dir: Vector3 = Vector3.ZERO


@onready var camera = $Camera/CameraPivot/SpringArm3D/Camera3D


@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25
@export var tilt_upper_limit := PI / 3.0
@export var tilt_lower_limit := -PI / 8.0

var move_dir: Vector3 = Vector3.ZERO
var gsp: float = 0.0:
	set(new_gsp):
		gsp = new_gsp
		abs_gsp = absf(gsp)

var abs_gsp: float = 0.0

var _camera_input_direction := Vector2.ZERO
var _last_movement_direction := Vector3.BACK
var _gravity := -30.0
var _gravity_normal: Vector3 = Vector3.UP 

#var slope_mag_dot: float
var slope_normal: Vector3 = get_floor_normal()
	#set(new_normal):
	#	slope_normal = new_normal
	#	slope_mag_dot = slope_normal.dot(_gravity_normal)


@onready var _camera: Camera3D = $Camera/CameraPivot/SpringArm3D/Camera3D
@onready var _body: Node3D = $Pivot/SONICGOOD

@onready var debug_label: Label = $Debug/Label

# DEBUG STUFF

func readable_vector(input:Vector3) -> String:
	return str(input.snappedf(0.01))

func readable_float(input:float) -> String:
	return str(snappedf(input, 0.01))

func add_debug_info(info:String) -> void:
	if debug_enabled:
		debug_label.text += info + "\n"

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _ready():
	camera.current = is_multiplayer_authority()

# func _unhandled_input(event: InputEvent) -> void:


func _physics_process(delta: float) -> void:

	debug_label.text = ""

	_camera_input_direction = Vector2.ZERO

	#var _axis: Vector3 = _gravity_normal.cross(slope_normal).normalized()
	
	var calcForward = _camera.global_position.direction_to(global_position).slide(up_direction)
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var input_3: Vector3 = Vector3(
		input_dir.x,
		0.0, 
		input_dir.y
		)
	
	var direction = ((calcForward.rotated(up_direction,deg_to_rad(90))*-input_dir.x)+(calcForward*-input_dir.y)).normalized()

	direction.y = 0.0
	direction = direction.normalized()

	var y_velocity := velocity.y
	velocity.y = 0.0
	
	var previous_velocity = velocity.dot(up_direction)

	
	if direction:
		if velocity.slide(up_direction).length() < move_speed:
			# main acceleration
			velocity = velocity.slide(up_direction).move_toward(direction * move_speed, acceleration * delta)+previous_velocity*up_direction
			add_debug_info("FUCK IM NOT TURING")
		else:
			# turning code
			velocity = velocity.slide(up_direction).slerp(direction * move_speed, acceleration * delta)+previous_velocity*up_direction
			add_debug_info("IM TURNING NIGGA")

	else:
		velocity = velocity.slerp(Vector3.ZERO,delta * deceleration)

	velocity.y = y_velocity + _gravity * delta

	var is_starting_jump := Input.is_action_just_pressed("jump") and is_on_floor()
	if is_starting_jump:
		velocity += up_direction * jump_impulse


	if direction.length() > 0.2:
		_last_movement_direction = direction
		
	var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	_body.global_rotation.y = lerp_angle(_body.rotation.y, target_angle, rotation_speed * delta)
	
	# HYPER THIS IS OLD CODE TAKEN FROM ANOTHER ENGINE

	#var slope_angle:float = acos(slope_mag_dot)
	#var slope_dir_dot: float = last_player_input_dir.dot(slope_normal)
	
	
	#if slope_mag_dot < 1.0 and slope_mag_dot > 0.0:
		#var downhill_factor:float 
		#var uphill_factor:float
		
		#uphill_factor = (100 * 0.75)
		#downhill_factor = 100

		#if slope_dir_dot < 0: # Downhill
		#	add_debug_info("RUNNING DOWNHILL")
		#	gsp += slope_angle * downhill_factor * delta
		#elif slope_dir_dot > 0: # Uphill
		#	add_debug_info("RUNNING UP THAT HILL") #kudos if you pick up the ref :trol:
		#	gsp -= slope_angle * uphill_factor * delta

	_body.animate(velocity)
	move_and_slide()
	

	add_debug_info("Input Vector: " + readable_vector(input_3))
	add_debug_info("Driection: " + readable_vector(direction))
	add_debug_info("Speed: " + readable_vector(velocity))
	add_debug_info("Target Angle: " + readable_float(target_angle))
	#add_debug_info("Ground Angle " + readable_float(rad_to_deg(acos(slope_mag_dot))))
	#add_debug_info("Slope direction: " + readable_float(slope_dir_dot))
	#add_debug_info("Slope angle: " + readable_float(rad_to_deg(slope_angle)))
	add_debug_info("Grounded?: " + readable_float(is_on_floor()))



# This doesnt work either ;-;

func apply_steering(input_dir: Vector3, delta: float) -> void:
	if input_dir == Vector3.ZERO:
		return
	
	var current_velocity = Vector3(velocity.x, 0, velocity.z)
	var current_speed = current_velocity.length()
	
	if current_speed < 10.5:
		# If too slow, directly apply input
		move_dir = input_dir.normalized()
		return
	
	var current_dir = current_velocity.normalized()
	var input_norm = input_dir.normalized()
	
	var angle_diff = rad_to_deg(acos(clampf(current_dir.dot(input_norm), -1.0, 1.0)))

	var _speed_ratio = move_speed / max_speed
# Use a non-linear curve for steer strength: stronger at low speeds, weaker at high speeds
	var k := 1.5  # steepness factor (higher = quicker dropoff)
	var _scale := 25.0  # "midpoint" speed (where curve bends)

# Smooth steering falloff
	var steer_strength = (1.0 / (2.0 + pow(current_speed / _scale, k))) * 15.0
	
	# Apply resistance to sharp turns (bigger angle = more speed lost)

	if angle_diff > 35.0:
		var loss_factor = clampf(angle_diff / 180.0, 0.0, 1.0)
		var speed_loss = current_speed * loss_factor * 0.08
		gsp = maxf(gsp - speed_loss, 0.0)

	# Gradually steer move_dir
	move_dir = current_dir.slerp(input_norm, steer_strength * delta).normalized()

	# Reapply velocity with new direction
	velocity.x = move_dir.x * gsp
	velocity.z = move_dir.z * gsp
