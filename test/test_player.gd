extends GutTest

func _create_player():
	var script = load("res://player.gd")
	var node = Node3D.new()
	node.set_script(script)
	return node

func test_default_speed():
	var player = _create_player()
	assert_eq(player.speed, 5.0, "기본 speed 는 5.0 이어야 한다")
	player.free()

func test_speed_is_exportable():
	var player = _create_player()
	player.speed = 10.0
	assert_eq(player.speed, 10.0, "speed 를 변경할 수 있어야 한다")
	player.free()

func test_calculate_velocity_forward():
	var player = _create_player()
	player.speed = 5.0
	var velocity = player.calculate_velocity(Vector3(0, 0, -1), 1.0)
	assert_eq(velocity, Vector3(0, 0, -5.0), "앞으로 이동 속도 계산")
	player.free()

func test_calculate_velocity_right():
	var player = _create_player()
	player.speed = 5.0
	var velocity = player.calculate_velocity(Vector3(1, 0, 0), 1.0)
	assert_eq(velocity, Vector3(5, 0, 0), "오른쪽 이동 속도 계산")
	player.free()

func test_calculate_velocity_with_delta():
	var player = _create_player()
	player.speed = 10.0
	var velocity = player.calculate_velocity(Vector3(0, 0, -1), 0.5)
	assert_eq(velocity, Vector3(0, 0, -5.0), "delta 적용 속도 계산")
	player.free()

func test_calculate_velocity_zero_direction():
	var player = _create_player()
	player.speed = 5.0
	var velocity = player.calculate_velocity(Vector3.ZERO, 1.0)
	assert_eq(velocity, Vector3.ZERO, "방향 없으면 속도 0")
	player.free()
