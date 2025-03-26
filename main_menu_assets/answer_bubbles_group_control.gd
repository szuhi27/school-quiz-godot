extends Control

@export var answer_bubble : PackedScene

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if data["origin_panel"] == "grid":
		return false
	return true

func _drop_data(at_position: Vector2, data: Variant) -> void:
	data["origin_node"].reset_to_base()
	
	var new_answer = answer_bubble.instantiate()
	new_answer.set_text(data["text"])
	$MarginContainer/ScrollContainer/AnswerBubblesGridContainer.add_child(new_answer)
