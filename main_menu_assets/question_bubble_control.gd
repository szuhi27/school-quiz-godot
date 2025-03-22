extends Node2D


func set_text(t: String):
	$Control/LineEdit.text = t

func set_global_position_x(f : float):
	global_position.x = f

func set_global_position_y(f: float):
	global_position.y = f
