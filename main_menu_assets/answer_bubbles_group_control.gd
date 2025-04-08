extends Control

@export var answer_bubble : PackedScene

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data["origin_panel"] == "grid":
		return false
	return true

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	data["origin_node"].reset_to_base()
	
	var new_answer = answer_bubble.instantiate()
	new_answer.set_text(data["text"])
	$MarginContainer/VBoxContainer/ScrollContainer/AnswerBubblesGridContainer.add_child(new_answer)

#=====ANSWER CHECKING=====

func _on_answer_bubbles_grid_container_child_exiting_tree(_node: Node) -> void:
	_set_check_button(1)

func _on_answer_bubbles_grid_container_child_entered_tree(_node: Node) -> void:
	_set_check_button(0)

func _set_check_button(m: int): #m = modifier because the way this medhtod works, mayb bad parctice?
	if $MarginContainer/VBoxContainer/ScrollContainer/AnswerBubblesGridContainer.get_child_count() == m:
		$CheckButton.show()
	else:
		$CheckButton.hide()
