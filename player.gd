extends Node3D

@export var speed: float = 5.0

var _mesh: MeshInstance3D

func _ready() -> void:
	_mesh = MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = Vector3(1.5, 1.5, 1.5)
	_mesh.mesh = box
	_mesh.position = Vector3(0, 0.75, 0)
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color.CORNFLOWER_BLUE
	_mesh.material_override = mat
	add_child(_mesh)

func _process(delta: float) -> void:
	var direction := _get_input_direction()
	if direction.length() > 0.0:
		direction = direction.normalized()
	position += direction * speed * delta

func _get_input_direction() -> Vector3:
	var direction := Vector3.ZERO
	if Input.is_key_pressed(KEY_W):
		direction.z -= 1.0
	if Input.is_key_pressed(KEY_S):
		direction.z += 1.0
	if Input.is_key_pressed(KEY_A):
		direction.x -= 1.0
	if Input.is_key_pressed(KEY_D):
		direction.x += 1.0
	return direction
