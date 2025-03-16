extends Node2D

var selected = false
var mouse_offset = Vector2(115, 23)

func _process(delta: float) -> void:
	if selected:
		position = get_global_mouse_position() + mouse_offset

#this should work, but apparently there is a problem with the current version of gogot (4.3)
#
#func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#print_debug("wn")
		#if event.pressed:
			#mouse_offset = position - get_global_mouse_position()
			#selected = true
		#else:
			#selected = false

func _on_delete_button_pressed() -> void:
	queue_free()

func _on_move_button_button_down() -> void:
	selected = true

func _on_move_button_button_up() -> void:
	selected = false

func get_text_lineedit() -> String:
	return $Control/LineEdit.text

func get_pos_x_lineedit() -> float:
	return $Control/LineEdit.global_position.x

func get_pos_y_lineedit() -> float:
	return $Control/LineEdit.global_position.y
