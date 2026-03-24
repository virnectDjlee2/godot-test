extends CharacterBody3D

@export var speed: float = 5.0

const GRAVITY: float = -9.8

func _physics_process(delta: float) -> void:
	var direction := Vector3.ZERO

	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1

	if direction != Vector3.ZERO:
		direction = direction.normalized()

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	move_and_slide()

func compute_velocity(direction: Vector3) -> Vector3:
	var dir := direction
	if dir != Vector3.ZERO:
		dir = dir.normalized()
	return Vector3(dir.x * speed, velocity.y, dir.z * speed)
