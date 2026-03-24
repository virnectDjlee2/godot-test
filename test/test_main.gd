extends GutTest

func _create_main():
	var script = load("res://main.gd")
	var node = Node3D.new()
	node.set_script(script)
	return node

func test_add_positive_numbers():
	var main = _create_main()
	assert_eq(main.add(2, 3), 5, "2 + 3 = 5")
	main.free()

func test_add_zero():
	var main = _create_main()
	assert_eq(main.add(0, 0), 0, "0 + 0 = 0")
	main.free()

func test_add_negative():
	var main = _create_main()
	assert_eq(main.add(-1, -2), -3, "-1 + -2 = -3")
	main.free()

func test_add_mixed():
	var main = _create_main()
	assert_eq(main.add(10, -3), 7, "10 + (-3) = 7")
	main.free()
