extends Node

@export var question_bubble : PackedScene
const WRONG_FILE : String = "Helytelen (vagy sérült) file! Kérem válasszon egy itt korábban létrehozott '.json' filet!"

func _ready() -> void:
	get_tree().get_root().files_dropped.connect(_on_files_dropped)

func  _on_files_dropped(files):
	if files.size() > 1:
		$Control2/ErrorLabel.text = "Csak egy filet válasszon ki!"
	elif files[0].get_extension() != "json":
		$Control2/ErrorLabel.text = WRONG_FILE
	else:
		var file = FileAccess.open(files[0], FileAccess.READ)
		_load_quiz(file.get_as_text())
		file.close()

#todo: validate the json
func _load_quiz(_json_string: String):
	var json_string = _json_string
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result == OK:
		var data = json.data
		
		if _validate_json(data):
			var image = Image.new()
			var correct_image = image.load_png_from_buffer(Marshalls.base64_to_raw(data["image"]))
			if correct_image == OK:
				var image_texture = ImageTexture.new()
				image_texture.set_image(image)
				$Control2/QuizImage.texture = image_texture
				
				_create_answer_bubbles(data["answer_bubbles"])
			else:
				$Control2/ErrorLabel.text = WRONG_FILE
		else:
			$Control2/ErrorLabel.text = WRONG_FILE
	else:
		$Control2/ErrorLabel.text = WRONG_FILE

func _create_answer_bubbles(data: Array):
	for i in data:
		var _new_question = question_bubble.instantiate()
		_new_question.set_global_position_x(i.global_position.x)
		_new_question.set_global_position_y(i.global_position.y)
		$QuestionGroup.add_child(_new_question)

func _validate_json(data: Variant) -> bool:
	if not (data.has("image") and data.has("answer_bubbles")):
		return false
	
	for i in data["answer_bubbles"]:
		if not (i.has("global_position") and i.has("text")):
			return false
		if not (i.global_position.has("x") and i.global_position.has("y")):
			return false
	
	return true
