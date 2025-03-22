extends Control

var selected = false
var mouse_offset = Vector2(0, 0)

func _process(delta: float) -> void:
	if selected:
		position = get_global_mouse_position() + mouse_offset

func _on_line_edit_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			selected = true
		else:
			selected = false

func _on_delete_button_pressed() -> void:
	queue_free()

func get_text_lineedit() -> String:
	return $LineEdit.text

func get_pos_x_lineedit() -> float:
	return global_position.x

func get_pos_y_lineedit() -> float:
	return global_position.y
