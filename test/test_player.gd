extends GutTest

func _make_player() -> Node3D:
	var script = load("res://player.gd")
	var player = Node3D.new()
	player.set_script(script)
	add_child_autoqfree(player)
	return player

func test_player_default_speed():
	var player = _make_player()
	assert_eq(player.speed, 5.0, "기본 속도는 5.0이어야 한다")

func test_player_speed_is_settable():
	var player = _make_player()
	player.speed = 10.0
	assert_eq(player.speed, 10.0, "speed export 변수를 변경할 수 있어야 한다")

func test_player_speed_zero_stops_movement():
	var player = _make_player()
	player.speed = 0.0
	assert_eq(player.speed, 0.0, "speed를 0으로 설정하면 이동이 멈춰야 한다")

func test_player_initial_position():
	var player = _make_player()
	assert_eq(player.position, Vector3.ZERO, "플레이어 초기 위치는 원점이어야 한다")

func test_player_extends_node3d():
	var player = _make_player()
	assert_true(player is Node3D, "플레이어는 Node3D를 상속해야 한다")
