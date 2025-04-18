extends Node

@export var question_bubble : PackedScene
@export var answer_bubble : PackedScene
@export var creator_scene: PackedScene

const WRONG_FILE : String = "Helytelen (vagy sérült) file! Kérem válasszon egy itt korábban létrehozott '.json' filet!"

var _quiz_data

func _ready() -> void:
	get_tree().get_root().files_dropped.connect(_on_files_dropped)

func _on_new_quiz_button_pressed() -> void:
	var new_creator_scene = creator_scene.instantiate()
	add_child(new_creator_scene)

func _on_import_quiz_button_pressed() -> void:
	$ImportQuizFileDialog.popup()

func _on_import_quiz_file_dialog_file_selected(path: String) -> void:
	_try_load_quiz_file(path)

func  _on_files_dropped(files):
	if files.size() > 1:
		$ImportGroup/ErrorLabel.text = "Csak egy filet válasszon ki!"
	else:
		_try_load_quiz_file(files[0])

#=====LOAD QUIZ=====

func _try_load_quiz_file(path: String):
	if path.get_extension() != "json":
		$ImportGroup/ErrorLabel.text = WRONG_FILE
	else:
		var file = FileAccess.open(path, FileAccess.READ)
		_reset_quiz()
		_validate_quiz(file.get_as_text())
		file.close()

#validation does not look too nice, but seems like there is not a better way in godot for error handling
#also maybe this is too overkill especially for the scope of the project, but practice
func _validate_quiz(_json_string: String):
	var json_string = _json_string
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	 
	if parse_result == OK:
		_quiz_data = json.data
		if _validate_json(_quiz_data):
			_load_quiz()
		else:
			$ImportGroup/ErrorLabel.text = WRONG_FILE
	else:
		$ImportGroup/ErrorLabel.text = WRONG_FILE

func _validate_json(data: Variant) -> bool:
	if not (data.has("image") and data.has("answer_bubbles")):
		return false
	
	for i in data["answer_bubbles"]:
		if not (i.has("global_position") and i.has("text")):
			return false
		if not (i.global_position.has("x") and i.global_position.has("y")):
			return false
	
	return true

func _load_quiz():
	var image = Image.new()
	var correct_image = image.load_png_from_buffer(Marshalls.base64_to_raw(_quiz_data["image"]))
	if correct_image == OK:
		var image_texture = ImageTexture.new()
		image_texture.set_image(image)
		$Control2/QuizImage.texture = image_texture
		
		_create_question_bubbles(_quiz_data["answer_bubbles"])
		
		$Control2/AnswerBubblesGroup.show()
		_create_answer_bubbles(_quiz_data["answer_bubbles"])
		
		$ImportGroup/ErrorLabel.text = ""
		$ImportGroup.hide()
	else:
		$ImportGroup/ErrorLabel.text = WRONG_FILE

func _create_question_bubbles(data: Array):
	for i in data:
		var new_question = question_bubble.instantiate()
		new_question.set_global_position_x(i.global_position.x)
		new_question.set_global_position_y(i.global_position.y)
		new_question.set_correct_answer(i.text)
		$Control2/QuestionGroup.add_child(new_question)

func _create_answer_bubbles(data: Array):
	data.shuffle()
	
	for i in data:
		var new_answer = answer_bubble.instantiate()
		new_answer.create_bubble(i.text)
		$Control2/AnswerBubblesGroup/MarginContainer/VBoxContainer/ScrollContainer/AnswerBubblesGridContainer.add_child(new_answer)

#=====

func _reset_quiz():
	$Control2/QuizImage.texture = null
	for child in $Control2/QuestionGroup.get_children():
		child.queue_free()
	for child in $Control2/AnswerBubblesGroup/MarginContainer/VBoxContainer/ScrollContainer/AnswerBubblesGridContainer.get_children():
		child.queue_free()
	$Control2/AnswerBubblesGroup.hide()
	$Control2/AnswerBubblesGroup/CorrectAnswerbutton.hide()
	$Control2/AnswerBubblesGroup/RetryButton.hide()

func _on_check_button_pressed() -> void:
	for question in $Control2/QuestionGroup.get_children():
		question.check_answer()
	
	$Control2/AnswerBubblesGroup/CheckButton.hide()
	$Control2/AnswerBubblesGroup/CorrectAnswerbutton.show()
	$Control2/AnswerBubblesGroup/RetryButton.show()

func _on_correct_answerbutton_pressed() -> void:
	for question in $Control2/QuestionGroup.get_children():
		question.show_correct_answer()

func _on_retry_button_pressed() -> void:
	_reset_quiz()
	_load_quiz()

func _on_close_quiz_button_pressed() -> void:
	_reset_quiz()
	$ImportGroup/ErrorLabel.text = ""
	$ImportGroup.show()
