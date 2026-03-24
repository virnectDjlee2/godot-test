extends Node3D

var cube: MeshInstance3D
var time := 0.0

func _ready():
	# 카메라
	var cam = Camera3D.new()
	cam.position = Vector3(0, 2, 5)
	cam.look_at(Vector3.ZERO)
	add_child(cam)

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
	plane.size = Vector2(10, 10)
	floor_mesh.mesh = plane
	floor_mesh.position = Vector3(0, -1, 0)
	var floor_mat = StandardMaterial3D.new()
	floor_mat.albedo_color = Color(0.2, 0.22, 0.25)
	floor_mesh.material_override = floor_mat
	add_child(floor_mesh)

	# 메인 큐브
	cube = MeshInstance3D.new()
	var box = BoxMesh.new()
	box.size = Vector3(1.5, 1.5, 1.5)
	cube.mesh = box
	cube.position = Vector3(0, 0.75, 0)
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color.CORNFLOWER_BLUE
	cube.material_override = mat
	add_child(cube)

	# 작은 구체들 (add 함수 결과 시각화)
	var results = [add(2, 3), add(-1, -2), add(10, -3)]
	var colors = [Color.GREEN_YELLOW, Color.ORANGE, Color.HOT_PINK]
	for i in range(3):
		var sphere_node = MeshInstance3D.new()
		var sphere = SphereMesh.new()
		sphere.radius = 0.25 + abs(results[i]) * 0.03
		sphere.height = sphere.radius * 2
		sphere_node.mesh = sphere
		var angle = i * TAU / 3.0
		sphere_node.position = Vector3(cos(angle) * 2.5, 0.3, sin(angle) * 2.5)
		var smat = StandardMaterial3D.new()
		smat.albedo_color = colors[i]
		smat.emission_enabled = true
		smat.emission = colors[i] * 0.5
		sphere_node.material_override = smat
		add_child(sphere_node)

	# 3D 텍스트
	var label = Label3D.new()
	label.text = "Godot 3D Test"
	label.font_size = 64
	label.position = Vector3(0, 3, 0)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	add_child(label)

	var sub_label = Label3D.new()
	sub_label.text = "Flow CLI Build Pipeline"
	sub_label.font_size = 32
	sub_label.modulate = Color.GRAY
	sub_label.position = Vector3(0, 2.5, 0)
	sub_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	add_child(sub_label)

func _process(delta):
	time += delta
	# 큐브 회전
	cube.rotation.y = time * 0.8
	cube.rotation.x = sin(time * 0.5) * 0.3
	# 살짝 위아래
	cube.position.y = 0.75 + sin(time * 1.2) * 0.2

func add(a: int, b: int) -> int:
	return a + b
