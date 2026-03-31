extends Node3D
## CAD 3D 뷰어 — 마우스/터치 orbit, zoom, pan
## MANIFOLD BLOCK ASSY glTF 모델을 로드하여 인터랙티브하게 조작

var camera: Camera3D
var pivot: Node3D  # 회전 중심점
var model: Node3D

# 카메라 설정
@export var zoom_speed: float = 0.1
@export var rotate_speed: float = 0.005
@export var pan_speed: float = 0.01
@export var min_zoom: float = 0.5
@export var max_zoom: float = 5000.0

var _camera_distance: float = 5.0
var _rotation_x: float = -30.0  # 상하 각도 (deg)
var _rotation_y: float = 45.0   # 좌우 각도 (deg)

# 입력 상태
var _dragging: bool = false
var _panning: bool = false
var _last_mouse: Vector2 = Vector2.ZERO

# 터치 상태
var _touches: Dictionary = {}  # touch_index → position
var _pinch_start_dist: float = 0.0
var _pinch_start_zoom: float = 0.0

func _ready() -> void:
	# 피벗 (회전 중심)
	pivot = Node3D.new()
	add_child(pivot)

	# 카메라
	camera = Camera3D.new()
	camera.far = 10000.0
	pivot.add_child(camera)

	# 환경
	_setup_environment()

	# glTF 모델 로드
	_load_model()

	# 초기 카메라 위치
	_update_camera()

func _setup_environment() -> void:
	# 조명
	var light := DirectionalLight3D.new()
	light.rotation_degrees = Vector3(-45, 30, 0)
	light.light_energy = 1.2
	add_child(light)

	var fill_light := DirectionalLight3D.new()
	fill_light.rotation_degrees = Vector3(30, -60, 0)
	fill_light.light_energy = 0.4
	add_child(fill_light)

	# 환경
	var env_node := WorldEnvironment.new()
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color(0.15, 0.15, 0.2)
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color(0.4, 0.4, 0.45)
	environment.ambient_light_energy = 0.5
	# gl_compatibility 렌더러 호환
	env_node.environment = environment
	add_child(env_node)

	# 그리드 바닥
	var grid := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(100, 100)
	grid.mesh = plane
	grid.position = Vector3(0, -0.01, 0)
	var grid_mat := StandardMaterial3D.new()
	grid_mat.albedo_color = Color(0.12, 0.12, 0.15, 0.5)
	grid_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	grid.material_override = grid_mat
	add_child(grid)

	# UI
	var label := Label3D.new()
	label.text = "MANIFOLD BLOCK ASSY"
	label.font_size = 32
	label.position = Vector3(0, 3, 0)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.modulate = Color(0.8, 0.8, 0.8, 0.7)
	add_child(label)

func _load_model() -> void:
	var gltf_path := "res://assets/models/manifold_block.glb"
	var scene := load(gltf_path) as PackedScene
	if scene == null:
		push_error("glTF 로드 실패: " + gltf_path)
		return

	model = scene.instantiate()
	add_child(model)

	# 모델 크기에 맞춰 카메라 거리 조정
	var aabb := _get_model_aabb(model)
	var size := aabb.size.length()
	_camera_distance = size * 2.0
	pivot.position = aabb.get_center()

	print("모델 로드 완료: AABB=", aabb.size, " center=", aabb.get_center())

func _get_model_aabb(node: Node) -> AABB:
	var aabb := AABB()
	var found := false
	for child in node.get_children():
		if child is MeshInstance3D:
			var mesh_aabb: AABB = child.get_aabb()
			var global_aabb: AABB = child.global_transform * mesh_aabb
			if not found:
				aabb = global_aabb
				found = true
			else:
				aabb = aabb.merge(global_aabb)
		# 재귀
		var child_aabb := _get_model_aabb(child)
		if child_aabb.size.length() > 0:
			if not found:
				aabb = child_aabb
				found = true
			else:
				aabb = aabb.merge(child_aabb)
	return aabb

func _update_camera() -> void:
	# 극좌표 → 카메라 위치
	_rotation_x = clampf(_rotation_x, -89.0, 89.0)
	_camera_distance = clampf(_camera_distance, min_zoom, max_zoom)

	var rot_x_rad := deg_to_rad(_rotation_x)
	var rot_y_rad := deg_to_rad(_rotation_y)

	camera.position = Vector3(
		_camera_distance * cos(rot_x_rad) * sin(rot_y_rad),
		_camera_distance * sin(rot_x_rad),
		_camera_distance * cos(rot_x_rad) * cos(rot_y_rad),
	)
	camera.look_at(Vector3.ZERO)

# ── 마우스 입력 ──────────────────────────────────────────────────

func _unhandled_input(event: InputEvent) -> void:
	# 마우스 휠 — 줌
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_WHEEL_UP:
			_camera_distance *= (1.0 - zoom_speed)
			_update_camera()
		elif mb.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_camera_distance *= (1.0 + zoom_speed)
			_update_camera()
		elif mb.button_index == MOUSE_BUTTON_LEFT:
			_dragging = mb.pressed
			_last_mouse = mb.position
		elif mb.button_index == MOUSE_BUTTON_RIGHT or mb.button_index == MOUSE_BUTTON_MIDDLE:
			_panning = mb.pressed
			_last_mouse = mb.position

	# 마우스 이동 — 회전/팬
	if event is InputEventMouseMotion:
		var mm := event as InputEventMouseMotion
		if _dragging:
			_rotation_y -= mm.relative.x * rotate_speed * 50
			_rotation_x += mm.relative.y * rotate_speed * 50
			_update_camera()
		elif _panning:
			var right := camera.global_transform.basis.x
			var up := camera.global_transform.basis.y
			pivot.position -= right * mm.relative.x * pan_speed * _camera_distance * 0.01
			pivot.position += up * mm.relative.y * pan_speed * _camera_distance * 0.01

	# 터치 입력
	if event is InputEventScreenTouch:
		var st := event as InputEventScreenTouch
		if st.pressed:
			_touches[st.index] = st.position
		else:
			_touches.erase(st.index)

	if event is InputEventScreenDrag:
		var sd := event as InputEventScreenDrag
		_touches[sd.index] = sd.position

		if _touches.size() == 1:
			# 1손가락 — 회전
			_rotation_y -= sd.relative.x * rotate_speed * 50
			_rotation_x += sd.relative.y * rotate_speed * 50
			_update_camera()
		elif _touches.size() == 2:
			# 2손가락 — 핀치 줌
			var keys := _touches.keys()
			var p1: Vector2 = _touches[keys[0]]
			var p2: Vector2 = _touches[keys[1]]
			var dist := p1.distance_to(p2)

			if _pinch_start_dist == 0.0:
				_pinch_start_dist = dist
				_pinch_start_zoom = _camera_distance
			else:
				var scale := _pinch_start_dist / maxf(dist, 1.0)
				_camera_distance = _pinch_start_zoom * scale
				_update_camera()

	# 핀치 종료 시 리셋
	if event is InputEventScreenTouch and not (event as InputEventScreenTouch).pressed:
		if _touches.size() < 2:
			_pinch_start_dist = 0.0
