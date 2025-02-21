extends Control


@export var answer_bubble : PackedScene

var _new_bubble : Node2D
var _selected_tower : Node2D
var _tower_controls : Node

func _physics_process(delta):
	if(_new_bubble != null):
		_new_bubble.global_position = get_global_mouse_position()


func _on_archer_button_button_down():
	_new_bubble = answer_bubble.instantiate()
	add_child(_selected_tower)

func _on_archer_button_button_up():
	if(_tower_controls.is_placeble()):
		_tower_controls.place_tower()
		_new_bubble = null
	else :
		_selected_tower.queue_free()
		_selected_tower = null
	
