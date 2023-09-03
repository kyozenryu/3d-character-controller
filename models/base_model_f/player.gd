extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var camera_controller : CameraController

@onready var animation_tree = $AnimationTree


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _process(delta):
	animation_controller()

func _physics_process(delta):

	# Get current mouse rotation for movement
	var h_rotation = camera_controller.global_transform.basis.get_euler().y
	var look = camera_controller.get_node("LookAt")

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "down", "up")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
#	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
#		direction = direction.rotated(Vector3.UP, h_rotation ).normalized()
	animation_tree.set("parameters/conditions/moving", direction != Vector3.ZERO)
	animation_tree.set("parameters/conditions/idle", direction == Vector3.ZERO)
	#print("Direction: ", direction)
	animation_tree.set("parameters/Moving/blend_position", Vector2(direction.x, direction.z))
#	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		
		
#	if direction != Vector3.ZERO:
#		rotation = (Vector3(rotation.x, atan2(direction.x, direction.z), rotation.z))
##		look_at(Vector3(look.global_position.x, global_position.y, look.global_position.z))

	var currentrotation = transform.basis.get_rotation_quaternion()
	velocity = (currentrotation.normalized() * animation_tree.get_root_motion_position()) / delta

	move_and_slide()




func animation_controller():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		animation_tree.set("parameters/J-OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	if velocity.is_zero_approx():
		animation_tree.set("parameters/Transition/transition_request", "idle")
	else:
		animation_tree.set("parameters/Transition/transition_request", "moving")
	
	animation_tree.set("parameters/Locomotion/blend_position", Vector2(velocity.z, velocity.x))
	
