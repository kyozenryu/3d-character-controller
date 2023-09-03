class_name CameraController
extends Node3D


@export var player : CharacterBody3D
@export var sensitivity := 5


@onready var spring = $SpringArm3D
@onready var camera = $SpringArm3D/Camera3D

var _invert := -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = player.global_position
	pass
	
	
	
	
func _input(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var _x = rotation.x + event.relative.y / 1000 * sensitivity
		print("Mouse look x : " , _x)
		var _y = rotation.y - event.relative.x / 1000 * sensitivity
		#print("Mouse look y: " , _y)
		
		rotation = Vector3(clamp( _x, -1, 0.25), _y, 0)
