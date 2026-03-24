extends GutTest

func _create_player() -> CharacterBody3D:
	var scene := load("res://player.tscn") as PackedScene
	var node := scene.instantiate() as CharacterBody3D
	add_child(node)
	return node

func test_default_speed():
	var player := _create_player()
	assert_eq(player.speed, 5.0, "기본 이동 속도는 5.0이어야 한다")
	player.queue_free()

func test_speed_can_be_changed():
	var player := _create_player()
	player.speed = 10.0
	assert_eq(player.speed, 10.0, "이동 속도를 10.0으로 변경할 수 있어야 한다")
	player.queue_free()

func test_compute_velocity_forward():
	var player := _create_player()
	var vel := player.compute_velocity(Vector3(0, 0, -1))
	assert_eq(vel.z, -5.0, "앞으로 이동시 z속도는 -speed여야 한다")
	player.queue_free()

func test_compute_velocity_right():
	var player := _create_player()
	var vel := player.compute_velocity(Vector3(1, 0, 0))
	assert_eq(vel.x, 5.0, "오른쪽 이동시 x속도는 speed여야 한다")
	player.queue_free()

func test_compute_velocity_zero_direction():
	var player := _create_player()
	var vel := player.compute_velocity(Vector3.ZERO)
	assert_eq(vel.x, 0.0, "방향이 없으면 x속도는 0이어야 한다")
	assert_eq(vel.z, 0.0, "방향이 없으면 z속도는 0이어야 한다")
	player.queue_free()

func test_compute_velocity_normalized_diagonal():
	var player := _create_player()
	var vel := player.compute_velocity(Vector3(1, 0, -1))
	var expected := 5.0 / sqrt(2.0)
	assert_almost_eq(vel.x, expected, 0.001, "대각선 이동시 속도가 정규화되어야 한다")
	player.queue_free()

func test_player_is_character_body():
	var player := _create_player()
	assert_true(player is CharacterBody3D, "플레이어는 CharacterBody3D여야 한다")
	player.queue_free()

func test_player_has_mesh():
	var player := _create_player()
	var mesh := player.get_node("MeshInstance3D") as MeshInstance3D
	assert_not_null(mesh, "플레이어에 MeshInstance3D가 있어야 한다")
	player.queue_free()

func test_player_has_collision():
	var player := _create_player()
	var col := player.get_node("CollisionShape3D") as CollisionShape3D
	assert_not_null(col, "플레이어에 CollisionShape3D가 있어야 한다")
	player.queue_free()
