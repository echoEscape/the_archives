extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Camera mouse movement
var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0
@onready var onr_twist_pivot := $TwistPivot
@onready var onr_pitch_pivot := $TwistPivot/PitchPivot

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	if Input.is_action_just_pressed("pause"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	onr_twist_pivot.rotate_y(twist_input)
	onr_pitch_pivot.rotate_x(pitch_input)
	#Limit rotation amount
	onr_pitch_pivot.rotation.x = clamp(onr_pitch_pivot.rotation.x, 
	deg_to_rad(-30),
	deg_to_rad(30))
	#Stop camera movement when you stop the mouse movement
	twist_input = 0.0
	pitch_input = 0.0
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	"""
	#From Test script for Movement with camera direction
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_backward")

	#Use Basis of Camera to move character with camera for WASD adjusting to where camera is looking
	apply_central_force(onr_twist_pivot.basis * input * 1200.0 * delta)
	"""

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity

