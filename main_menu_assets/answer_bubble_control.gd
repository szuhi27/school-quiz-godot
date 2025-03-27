extends LineEdit

func _get_drag_data(_at_position: Vector2) -> Variant:
	var data = {}
	data["text"] = text
	data["origin_node"] = self
	data["origin_panel"] = "grid"
	
	set_drag_preview(_create_drag_preview(text))
	return data

func _create_drag_preview(t : String) -> Variant:
	var le = LineEdit.new()
	le.expand_to_text_length = true
	le.alignment = HORIZONTAL_ALIGNMENT_CENTER
	le.flat = true
	le.set_text(t)
	
	var clr = ColorRect.new()
	clr.color = Color.BLACK
	clr.show_behind_parent = true
	clr.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	le.add_child(clr)
	
	var prev = Control.new()
	prev.add_child(le)
	le.position.x = -0.5 * le.size.x
	le.position.y = -0.5 * le.size.y
	
	return prev
