extends Node

var _image_file_name 
var _image_data

func _ready() -> void:
	get_tree().get_root().files_dropped.connect(_on_files_dropped)

func _on_button_pressed() -> void:
	$ImageImportGroup/FileDialog.popup()

func _on_file_dialog_file_selected(path: String) -> void:
	_load_image(path)

func _on_files_dropped(files):
	if files.size() > 1:
		$ImageImportGroup/ErrorMsg.text = "Egyszerre egy képet válasszon!"
	else:
		_load_image(files[0])

func _load_image(path: String):
	var image = Image.new()
	var try_load_image = image.load(path)
	
	if try_load_image == OK:
		image.load(path)
		
		var image_texture = ImageTexture.new()
		image_texture.set_image(image)
		$Control/QuizImage.texture = image_texture
		$ImageImportGroup.visible = false
		
		_image_file_name = path.get_file()
		_image_data = image.save_png_to_buffer()
		
		$BubbleAdder.show()
	else :
		$ImageImportGroup/ErrorMsg.text = "Nem megfelelő fájltípus!"

#=====SAVING THE QUIZ=====

func _on_save_button_pressed() -> void:
	$SaveFileDialog.current_file = _image_file_name.get_slice(".",0)
	$SaveFileDialog.popup()

#this works, dir_select does not
func _on_save_file_dialog_file_selected(path: String) -> void:
	_save_quiz(path)

func _save_quiz(path: String):
	var json_data = {}
	
	var base64_string = Marshalls.raw_to_base64(_image_data)
	json_data["image"] = base64_string
	
	var json_string = JSON.stringify(json_data)
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(json_string)
	file.close()
	
	#todo: go to main screen
