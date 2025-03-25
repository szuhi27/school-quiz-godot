extends LineEdit

var size_x_before_change : float

func _ready() -> void:
	size_x_before_change = size.x

func set_global_position_x(f : float):
	global_position.x = f - (size.x / 2.0)

func set_global_position_y(f: float):
	global_position.y = f - (size.y / 2.0)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true

func _drop_data(at_position: Vector2, data: Variant) -> void:
	text = data
	_resize()

func _resize():
	position.x -= size.x / 2.0 + size_x_before_change
	size_x_before_change = size.x
