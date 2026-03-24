extends Node3D

@export var speed: float = 5.0

func _process(delta: float) -> void:
	var direction = _get_input_direction()
	position += direction * speed * delta

func _get_input_direction() -> Vector3:
	var direction = Vector3.ZERO
	if Input.is_key_pressed(KEY_W):
		direction.z -= 1.0
	if Input.is_key_pressed(KEY_S):
		direction.z += 1.0
	if Input.is_key_pressed(KEY_A):
		direction.x -= 1.0
	if Input.is_key_pressed(KEY_D):
		direction.x += 1.0
	return direction.normalized()
