extends Node3D

var player: CharacterBody3D
var camera: Camera3D

const CAMERA_OFFSET := Vector3(0, 4, 7)

func _ready() -> void:
	# 카메라
	camera = Camera3D.new()
	camera.position = CAMERA_OFFSET
	camera.look_at(Vector3.ZERO)
	add_child(camera)

	# 조명
	var light := DirectionalLight3D.new()
	light.rotation_degrees = Vector3(-45, 30, 0)
	add_child(light)

	# 환경광
	var env := WorldEnvironment.new()
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color(0.12, 0.12, 0.18)
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color(0.3, 0.3, 0.4)
	env.environment = environment
	add_child(env)

	# 바닥
	var floor_body := StaticBody3D.new()
	var floor_mesh := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(20, 20)
	floor_mesh.mesh = plane
	var floor_mat := StandardMaterial3D.new()
	floor_mat.albedo_color = Color(0.2, 0.22, 0.25)
	floor_mesh.material_override = floor_mat
	floor_body.add_child(floor_mesh)
	var floor_shape := CollisionShape3D.new()
	var box_shape := BoxShape3D.new()
	box_shape.size = Vector3(20, 0.1, 20)
	floor_shape.shape = box_shape
	floor_shape.position = Vector3(0, -0.05, 0)
	floor_body.add_child(floor_shape)
	add_child(floor_body)

	# 플레이어
	var player_scene := load("res://player.tscn") as PackedScene
	player = player_scene.instantiate() as CharacterBody3D
	player.position = Vector3(0, 0.75, 0)
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color.CORNFLOWER_BLUE
	player.get_node("MeshInstance3D").material_override = mat
	add_child(player)

	# 3D 텍스트
	var label := Label3D.new()
	label.text = "WASD로 이동하세요"
	label.font_size = 48
	label.position = Vector3(0, 4, 0)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	add_child(label)

func _process(_delta: float) -> void:
	if player:
		camera.position = player.position + CAMERA_OFFSET
		camera.look_at(player.position)

func add(a: int, b: int) -> int:
	return a + b
