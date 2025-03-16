extends Node

@export var question_bubble : PackedScene

func _ready() -> void:
	get_tree().get_root().files_dropped.connect(_on_files_dropped)

#todo: check if .json and accept only 1
func  _on_files_dropped(files):
	if files.size() == 1:
		var file = FileAccess.open(files[0], FileAccess.READ)
		_load_quiz(file.get_as_text())
		file.close()

#todo: validate the json
func _load_quiz(_json_string: String):
	var json_string = _json_string
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	var data = json.data
	
	var image = Image.new()
	image.load_png_from_buffer(Marshalls.base64_to_raw(data["image"]))
	var image_texture = ImageTexture.new()
	image_texture.set_image(image)
	$Control2/QuizImage.texture = image_texture
	
	_create_answer_bubbles(data["answer_bubbles"])

func _create_answer_bubbles(data: Array):
	for i in data:
		var _new_question = question_bubble.instantiate()
		#_new_question.set_global_position_x(i.global_position.x)
		#_new_question.set_global_position_y(i.global_position.y)
		_new_question.global_position.x = i.global_position.x
		_new_question.global_position.y = i.global_position.y
		$QuestionGroup.add_child(_new_question)
