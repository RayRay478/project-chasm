extends CharacterBody3D

class_name PlayerMain

const debug_enabled: bool = true


@export_group("Movement")
@export var move_speed := 20.0
@export var max_speed := 40.0

@export var acceleration := 20.0
@export var acceleration_curve: Curve
@export var deceleration := 20.0
@export var rotation_speed := 12.0
@export var jump_impulse := 12.0
@export var jump_max := 12.0
@export var turnspeed_curve: Curve
@export var _gravity := -30.0
@export var slope_gravity := 1.2   # the strength of slopes' gravity
@export var ground_friction := 12.0
@export var max_downhill_accel := 30.0
@export var max_uphill_accel := 20.0
@export var uphill_drag_build := 0.8     # builds while climbing
@export var uphill_drag_decay := 1.6     # recovers when not climbing
@export var uphill_drag_max_loss := 0.5  # extra target-speed loss at full drag
@export var uphill_min_speed_ratio := 0.25  # doesn't drop below 25% of move_speed from drag


# STATES LERS GOO
var hurt_state: bool = false
var air_state: bool = false
var jump_state: bool  = false
var running_state: bool = false
var turning_state: bool = false


var accel_speed: float = 0.0
var last_player_input_dir: Vector3 = Vector3.ZERO
var uphill_drag: float = 0.0 # 0..1



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

var camera_input_direction := Vector2.ZERO
var _last_movement_direction := Vector3.BACK
#var _gravity_normal: Vector3 = Vector3.UP 

#var slope_mag_dot: float
var slope_normal: Vector3 = get_floor_normal()
	#set(new_normal):
	#	slope_normal = new_normal
	#	slope_mag_dot = slope_normal.dot(_gravity_normal)

@export_group("Debug")
@export var camera: Camera3D
@export var body: Body
# @export var body: Node3D 
# (Body instead of Node3D might help avoid errors for things like body.animate() - h)
@export var debug_label: Label


# ^^ DEBUG STUFF ^^ - (added var camera here just for better organization - h)

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
	if event.is_action_pressed("ui_accept"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _enter_tree():
	set_multiplayer_authority(int(str(name)))


func _ready():

	if camera:
		camera.current = is_multiplayer_authority()


# func _unhandled_input(event: InputEvent) -> void:


func _physics_process(delta: float) -> void:
	#if camera == null or body == null or debug_label == null:
	#	return
	
	
	if camera == null or body == null or debug_label == null:
		print("Missing refs:",
			" camera=", camera,
			" body=", body,
			" debug_label=", debug_label)
		return

	# rest of movement...


	debug_label.text = ""
	camera_input_direction = Vector2.ZERO

	

	#var _axis: Vector3 = _gravity_normal.cross(slope_normal).normalized()
	
	#var calcForward = _camera.global_position.direction_to(global_position).slide(up_direction)
	var calcForward = camera.global_position.direction_to(global_position).slide(up_direction)

	
	
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
	# accel_speed = velocity.length() / move_speed (old code for safekeeping - h)
	var horiz_speed := velocity.slide(up_direction).length()
	accel_speed = clampf(horiz_speed / move_speed, 0.0, 1.0)
	# (clampf is "clamp float." takes a number and forces it to stay WITHIN the min and max ranges - h)

	
	if direction:
		var target_speed := move_speed

		if is_on_floor():
			var n := get_floor_normal()
			var g_vec := up_direction * _gravity
			var downhill := g_vec.slide(n)
			var downhill_len := downhill.length()

			if downhill_len > 0.001:
				var downhill_dir := downhill / downhill_len

		# 0..1 steepness (flat -> steep)
				var steep := clampf(downhill_len / absf(_gravity), 0.0, 1.0)

		# how "uphill" the input direction is (0 downhill/flat, 1 fully uphill)
				var uphillness := clampf((-direction).dot(downhill_dir), 0.0, 1.0)

		# tune this (0.3..0.8). Higher = more speed loss uphill.
				var uphill_loss := 0.6

		# reduce target speed uphill based on steepness
				target_speed *= (1.0 - uphill_loss * uphillness * steep)
				
							# Build/decay uphill drag over time (stateful slowdown)
				var climbing := uphillness * steep  # 0..1

			# only build drag if we're actually moving
				var moving := velocity.slide(up_direction).length() > 0.5
				if not moving:
					climbing = 0.0

					uphill_drag = clampf(
							uphill_drag + climbing * uphill_drag_build * delta
							- (1.0 - climbing) * uphill_drag_decay * delta,
							0.0, 1.0
			)

			# Apply extra loss that increases the longer you climb
					target_speed *= (1.0 - uphill_drag_max_loss * uphill_drag)

			# Prevent target from collapsing to near-zero
			target_speed = maxf(target_speed, move_speed * uphill_min_speed_ratio)


		if velocity.slide(up_direction).length() < move_speed:

			# main acceleration
		#	velocity = velocity.slide(up_direction).move_toward(direction * move_speed, acceleration * delta)+previous_velocity*up_direction
			var horiz := velocity.slide(up_direction)
			var speed := horiz.length()
			var t := clampf(speed / move_speed, 0.0, 1.0)

			var curve_val := acceleration_curve.sample(t)
			var min_curve := 0.25 # tune: 0.10–0.35
			var accel_step := acceleration * maxf(curve_val, min_curve) * delta

			#swapped from move_speed to target_speed for uphill math
			velocity = horiz.move_toward(direction * target_speed, accel_step)
			add_debug_info("FUCK IM NOT TURNING")

		else:
			# turning code (old for safekeeping. doing some fuckshit magic rn - h)
			# velocity = velocity.slide(up_direction).move_toward(direction * move_speed, 1)
			var turn_step := acceleration * 2 * delta  # tune this
			velocity = velocity.slide(up_direction).move_toward(direction * target_speed, turn_step)
			rotation_speed = 7
			add_debug_info("IM TURNING YOOOOO!!!") # hyper got rid of "nigga", we should hang him - ray


	else:
		velocity = velocity.slerp(Vector3.ZERO,delta * deceleration)+previous_velocity*up_direction
		add_debug_info("damn fucker, MOVE")
	velocity.y = y_velocity + _gravity * delta

	var is_starting_jump := Input.is_action_pressed("jump") and is_on_floor()
	if is_starting_jump:
		velocity += up_direction * jump_max
		jump_state = true
	if jump_state and not Input.is_action_pressed("jump"):
		if velocity.y > jump_impulse:
			velocity.y *= 0.6
		jump_state = false
	



	if direction.length() > 0.2:
		_last_movement_direction = direction
		
	var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	body.global_rotation.y = lerp_angle(body.rotation.y, target_angle, rotation_speed * delta)
	
	# HYPER THIS IS OLD SLOPE CODE TAKEN FROM ANOTHER ENGINE

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
		#	add_debug_info("RUNNING UP THAT HILL") (#kudos if you pick up the ref :trol:- r) (i hate it. - h)
		#	gsp -= slope_angle * uphill_factor * delta

# =========================================================================
	move_and_slide() 
	# HYPER'S INSANE PHYSICS BULLSHIT HERE WE GO
	if is_on_floor():
		var n := get_floor_normal()
		var horiz := velocity.slide(up_direction)

		var g_vec := up_direction * _gravity          # points down
		var downhill := g_vec.slide(n)                # gravity along slope plane
		var downhill_len := downhill.length()

		if downhill_len > 0.001:
			var downhill_dir := downhill / downhill_len
			var along := horiz.dot(downhill_dir)

	# Steepness (0 = flat, 1 = very steep)
			var steep := clampf(downhill_len / absf(_gravity), 0.0, 1.0)

			var downhill_mul := 1.4
			var uphill_base := 0.6
			var uphill_extra := 2.0

			var mul := downhill_mul if along > 0.0 else (uphill_base + uphill_extra * steep)

	# downhill_len already represents acceleration along the slope
			var slope_accel := downhill_len * slope_gravity * mul

	# Cap effect so nothing explodes
			slope_accel = clampf(slope_accel, -max_uphill_accel, max_downhill_accel)

			horiz += downhill_dir * (slope_accel * delta)

	# prevents sonic from GETTING FLUNG when he so much as GRAZES a slope
			if along < 0.0:
				var new_along := horiz.dot(downhill_dir)
				new_along = maxf(new_along, 0.0)
				horiz = horiz.slide(downhill_dir) + downhill_dir * new_along
		

		#var n := get_floor_normal()

		#var horiz := velocity.slide(up_direction)
		#var speed := horiz.length()
		#var ground_dir := horiz.normalized() if speed > 0.05 else _last_movement_direction.normalized()

		#var g_vec := up_direction * _gravity
		#var g_parallel := g_vec.slide(n)
		#var slope_push := g_parallel.dot(ground_dir)

		#horiz += ground_dir * (slope_push * slope_gravity * delta)

		#if direction.length() < 0.1:
		#	horiz = horiz.move_toward(Vector3.ZERO, ground_friction * delta)

		#velocity.x = horiz.x
		#velocity.z = horiz.z

	# updates accel+speed AFTER being on a slope
	#horiz_speed = velocity.slide(up_direction).length()
	#accel_speed = clampf(horiz_speed / move_speed, 0.0, 1.0)

	body.animate(velocity)

	add_debug_info("Input Vector: " + readable_vector(input_3))
	add_debug_info("Driection: " + readable_vector(direction))
	add_debug_info("Velocity: " + readable_vector(velocity))
	add_debug_info("Speed Up?: " + readable_float(accel_speed))
	
	add_debug_info("Target Angle: " + readable_float(target_angle))
	#add_debug_info("Ground Angle " + readable_float(rad_to_deg(acos(slope_mag_dot))))
	#add_debug_info("Slope direction: " + readable_float(slope_dir_dot))
	#add_debug_info("Slope angle: " + readable_float(rad_to_deg(slope_angle)))
	add_debug_info("Grounded?: " + readable_float(is_on_floor()))
	add_debug_info("Character: " + readable_float(Global.characterID))
	add_debug_info("CharacterRN?: " + str(Global.player_char))
	add_debug_info("Jumping: " + str(jump_state))
