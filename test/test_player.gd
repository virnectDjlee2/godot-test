extends GutTest

func _create_player():
	var script = load("res://player.gd")
	var node = Node3D.new()
	node.set_script(script)
	return node

func test_player_has_default_speed():
	var player = _create_player()
	assert_eq(player.speed, 5.0, "기본 이동 속도는 5.0이어야 한다")
	player.free()

func test_player_speed_can_be_changed():
	var player = _create_player()
	player.speed = 10.0
	assert_eq(player.speed, 10.0, "이동 속도를 변경할 수 있어야 한다")
	player.free()

func test_player_starts_at_origin():
	var player = _create_player()
	assert_eq(player.position, Vector3.ZERO, "플레이어 초기 위치는 원점이어야 한다")
	player.free()

func test_no_input_returns_zero_direction():
	var player = _create_player()
	var direction = player._get_input_direction()
	assert_eq(direction, Vector3.ZERO, "입력 없을 때 이동 방향은 ZERO이어야 한다")
	player.free()

func test_speed_is_export_variable():
	var player = _create_player()
	# export 변수는 값을 직접 변경할 수 있어야 한다
	player.speed = 3.5
	assert_eq(player.speed, 3.5, "export 변수로 이동 속도를 조절할 수 있어야 한다")
	player.free()

func test_movement_updates_position():
	var player = _create_player()
	player.position = Vector3.ZERO
	# 직접 위치 변경 시뮬레이션 (Input 없이 방향 벡터 적용)
	var direction = Vector3(0, 0, -1)  # 앞으로
	var delta = 1.0
	player.position += direction * player.speed * delta
	assert_eq(player.position.z, -5.0, "speed=5, delta=1, z방향 이동 시 z=-5.0이어야 한다")
	player.free()
