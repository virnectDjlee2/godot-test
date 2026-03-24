extends Camera3D

@export var offset: Vector3 = Vector3(0, 5, 8)

var _target: Node3D = null

func set_follow_target(target: Node3D) -> void:
	_target = target

func _process(_delta):
	if _target:
		global_position = _target.global_position + offset
		look_at(_target.global_position)
