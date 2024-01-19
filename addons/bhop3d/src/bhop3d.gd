extends CharacterBody3D

@export_category("Activity Controls")
## Whether the character is currently able to look around
@export var look_enabled : bool = true : 
	get:
		return move_enabled
	set(val): ## Automatically update the mouse mode when look_enabled changes
		look_enabled = val
		update_mouse_mode()
## Whether the character is currently able to move
@export var move_enabled : bool = true
@export var jump_when_held : bool = false

@export_category("Input Definitions")
## Mouse sensitivity multiplier
@export var sensitivity : Vector2 = Vector2.ONE
## Movement actions
@export var move_forward : String
@export var move_backward : String
@export var move_left : String
@export var move_right : String
@export var jump : String

@export_category("Movement Variables")
## Gravity
@export var gravity : float = 30
## Acceleration when grounded
@export var ground_accelerate : float = 250
## Acceleration when in the air
@export var air_accelerate : float = 85
## Max velocity on the ground
@export var max_ground_velocity : float = 10
## Max velocity in the air
@export var max_air_velocity : float = 1.5
## Jump force multiplier
@export var jump_force : float = 1
## Friction
@export var friction : float = 6
## Bunnyhop window frame length
@export var bhop_frames : int = 2

@export_category("Controlled Nodes")
## Camera to update with mouse controls
@export var camera : Camera3D

## Utility function for setting mouse mode, always visible if camera is unset
func update_mouse_mode():
	if look_enabled and camera:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func mouse_look(event):
	# Mouse look controls, don't activate if camera is unset
	if look_enabled and camera:
		if event is InputEventMouseMotion:
			rotate_y(deg_to_rad(-event.relative.x * sensitivity.y))
			camera.rotate_x(deg_to_rad(-event.relative.y * sensitivity.x))
			rotation.x = clamp(rotation.x, deg_to_rad(-89), deg_to_rad(89))

## Get player's intended direction. (0,0) if movement disabled
func get_wishdir():
	if not move_enabled:
		return Vector3.ZERO
	return Vector3.ZERO + \
			(transform.basis.z * Input.get_axis(move_forward, move_backward)) +\
			(transform.basis.x * Input.get_axis(move_left, move_right))

## Get jump force
func get_jump():
	return sqrt(4 * jump_force * gravity)

## Get gravity force
func get_gravity(delta):
	return gravity * delta

######
# All this code was only possible thanks to the technical writeup by Flafla2 available below.
# Most of this was shamelessly adjusted from direct copy-pasting.
#
# Bunnyhopping from the Programmer's Perspective
# https://adrianb.io/2015/02/14/bunnyhop.html
######

## Source-like acceleration function
func accelerate(accelDir, prevVelocity, acceleration, max_vel, delta):
	# Calculate projected velocity for the next frame
	var projectedVel = prevVelocity.dot(accelDir)
	# Calculate the accelerated velocity given the maximum velocity, projected velocity, and current acceleration
	var accelVel = clamp(max_vel - projectedVel, 0, acceleration * delta)
	# Return the previous velocity in addition to the new velocity post acceleration
	return prevVelocity + accelDir * accelVel

## Get intended velocity for the next frame
func get_next_velocity(previousVelocity, delta):
	var grounded = is_on_floor()
	var max_vel = max_ground_velocity if grounded else max_air_velocity
	var accel = ground_accelerate if grounded else air_accelerate
	
	# Apply friction if player is grounded, and if the frame_timer indicates it should be applied
	if grounded and (frame_timer > bhop_frames):
		var speed = previousVelocity.length()
		if speed != 0:
			var drop = speed * friction * delta
			previousVelocity *= max(speed - drop, 0) / speed
	
	# Calculate velocity for next frame
	var velocity = accelerate(get_wishdir(), previousVelocity, accel, max_vel, delta)
	# Apply gravity
	velocity += Vector3.DOWN * get_gravity(delta)
	
	# Apply jump if desired
	# Godot won't let me put the ternary if/else in the if statement ahead
	if (Input.is_action_pressed(jump) if jump_when_held else Input.is_action_just_pressed(jump)) \
			and move_enabled and grounded:
		velocity.y = get_jump()
	
	# Return the new velocity
	return velocity

## Count of frames since last grounded
var frame_timer = bhop_frames
## Update frame timer if necessary
func update_frame_timer():
	if is_on_floor():
		frame_timer += 1
	else:
		frame_timer = 0

## Get frame velocity and update character body
func handle_movement(delta):
	print(velocity.length())
	velocity = get_next_velocity(velocity, delta)
	move_and_slide()

### Godot internal functions
func _physics_process(delta):
	handle_movement(delta)

func _unhandled_input(event):
	mouse_look(event)

func _ready():
	update_mouse_mode()
