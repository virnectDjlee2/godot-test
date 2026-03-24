extends Node3D

var camera: Camera3D
var player: Node3D
var time := 0.0

const CAMERA_OFFSET := Vector3(0, 5, 8)
const CAMERA_FOLLOW_SPEED := 8.0

func _ready():
	# 카메라
	camera = Camera3D.new()
	camera.position = CAMERA_OFFSET
	camera.look_at(Vector3.ZERO)
	add_child(camera)

	# 조명
	var light = DirectionalLight3D.new()
	light.rotation_degrees = Vector3(-45, 30, 0)
	add_child(light)

	# 환경광 (너무 어둡지 않게)
	var env = WorldEnvironment.new()
	var environment = Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color(0.12, 0.12, 0.18)
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color(0.3, 0.3, 0.4)
	env.environment = environment
	add_child(env)

	# 바닥 (평면)
	var floor_mesh = MeshInstance3D.new()
	var plane = PlaneMesh.new()
	plane.size = Vector2(20, 20)
	floor_mesh.mesh = plane
	floor_mesh.position = Vector3(0, -0.01, 0)
	var floor_mat = StandardMaterial3D.new()
	floor_mat.albedo_color = Color(0.2, 0.22, 0.25)
	floor_mesh.material_override = floor_mat
	add_child(floor_mesh)

	# 플레이어 (player.tscn 인스턴스)
	var player_scene = load("res://player.tscn")
	player = player_scene.instantiate()
	player.position = Vector3(0, 0, 0)
	add_child(player)

	# 3D 텍스트
	var label = Label3D.new()
	label.text = "WASD로 이동하세요"
	label.font_size = 48
	label.position = Vector3(0, 4, 0)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	add_child(label)

func _process(delta):
	time += delta

	# 카메라가 플레이어를 따라감
	if player:
		var target_pos = player.position + CAMERA_OFFSET
		camera.position = camera.position.lerp(target_pos, CAMERA_FOLLOW_SPEED * delta)
		camera.look_at(player.position + Vector3(0, 0.75, 0))

func add(a: int, b: int) -> int:
	return a + b
