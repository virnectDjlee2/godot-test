extends Node3D

var player: Node3D

func _ready():
	# 조명
	var light = DirectionalLight3D.new()
	light.rotation_degrees = Vector3(-45, 30, 0)
	add_child(light)

	# 환경광
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
	floor_mesh.position = Vector3(0, -1, 0)
	var floor_mat = StandardMaterial3D.new()
	floor_mat.albedo_color = Color(0.2, 0.22, 0.25)
	floor_mesh.material_override = floor_mat
	add_child(floor_mesh)

	# 플레이어 노드 (큐브)
	player = Node3D.new()
	player.set_script(load("res://player.gd"))
	player.position = Vector3(0, 0.75, 0)
	add_child(player)

	var cube = MeshInstance3D.new()
	var box = BoxMesh.new()
	box.size = Vector3(1.5, 1.5, 1.5)
	cube.mesh = box
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color.CORNFLOWER_BLUE
	cube.material_override = mat
	player.add_child(cube)

	# 3D 텍스트
	var label = Label3D.new()
	label.text = "WASD로 이동"
	label.font_size = 64
	label.position = Vector3(0, 2.5, 0)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	player.add_child(label)

	# 팔로우 카메라
	var cam = Camera3D.new()
	cam.set_script(load("res://follow_camera.gd"))
	add_child(cam)
	cam.set_follow_target(player)

func add(a: int, b: int) -> int:
	return a + b
