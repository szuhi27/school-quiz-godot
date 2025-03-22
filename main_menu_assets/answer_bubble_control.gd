extends LineEdit

var selected = false
var mouse_offset = Vector2(0,0)



func _on_gui_input(event: InputEvent) -> void:

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		print_debug("wn 2")
		#if event.pressed:
			#mouse_offset = position - get_global_mouse_position()
			#selected = true
		#else:
			#selected = false
