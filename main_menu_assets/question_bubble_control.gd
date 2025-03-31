extends LineEdit

@export var good_answer_texture : Texture2D
@export var bad_answer_texture : Texture2D

var _size_x_before_change : float
var _base_size_x
var _base_position
var _correct_answer

func _ready() -> void:
	_size_x_before_change = size.x
	_base_size_x = size.x
	_base_position = Vector2(global_position.x, global_position.y)

func set_global_position_x(f : float):
	global_position.x = f - (size.x / 2.0)

func set_global_position_y(f: float):
	global_position.y = f - (size.y / 2.0)

func set_correct_answer(answ : String):
	_correct_answer = answ


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data["origin_node"] == self:
		return false
	return true

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if self.text == "":
		self.text = data["text"]
		if data["origin_panel"] == "grid":
			data["origin_node"].queue_free()
		else:
			data["origin_node"].reset_to_base()
	elif data["origin_panel"] == "question":
		data["origin_node"].text = self.text 
		self.text = data["text"]
		
	#potential uprgade: make it possible swap between image and grid
	
	#_resize()

#potential upgrade, resizing so the bubble is centered after an answer is set
#func _resize():
	#position.x -= size.x / 2.0 #+ base_size_x/2.0)

func reset_to_base():
	text = ""
	position = _base_position
	size.x = _base_size_x

func _get_drag_data(_at_position: Vector2) -> Variant:
	var data = {}
	data["text"] = text
	data["origin_node"] = self
	data["origin_panel"] = "question"
	
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


func check_answer():
	if _correct_answer == text:
		$TextureRect.texture = good_answer_texture
	else:
		$TextureRect.texture = bad_answer_texture
	
	add_theme_color_override("font_uneditable_color",Color.BLACK) 
