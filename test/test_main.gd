extends GutTest

# main.gd의 add 함수를 테스트

func test_add_positive_numbers():
	var main = load("res://main.gd").new()
	assert_eq(main.add(2, 3), 5, "2 + 3 = 5")
	main.free()

func test_add_zero():
	var main = load("res://main.gd").new()
	assert_eq(main.add(0, 0), 0, "0 + 0 = 0")
	main.free()

func test_add_negative():
	var main = load("res://main.gd").new()
	assert_eq(main.add(-1, -2), -3, "-1 + -2 = -3")
	main.free()

func test_add_mixed():
	var main = load("res://main.gd").new()
	assert_eq(main.add(10, -3), 7, "10 + (-3) = 7")
	main.free()
