extends Control


@export var answer_bubble : PackedScene

var _new_bubble : Node2D

func _physics_process(delta):
	if(_new_bubble != null):
		_new_bubble.global_position = get_global_mouse_position()

func _on_answe_bubble_creatot_button_button_down() -> void:
	_new_bubble = answer_bubble.instantiate()
	add_child(_new_bubble)

func _on_answe_bubble_creatot_button_button_up() -> void:
	_new_bubble = null
