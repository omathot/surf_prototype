extends CharacterBody3D

const MAX_SPEED = 10.0
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.002

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	velocity.y += -gravity * delta
	var input = Input.get_vector("left", "right", "forward", "backward")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = movement_dir.x * SPEED
	velocity.z = movement_dir.z * SPEED

	move_and_slide()
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		$PlayerCamera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		$PlayerCamera.rotation.x = clampf($PlayerCamera.rotation.x, -deg_to_rad(70), deg_to_rad(70))
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
