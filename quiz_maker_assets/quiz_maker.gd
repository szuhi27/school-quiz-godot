extends Node

var _image = Image

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
	_image = Image.new()
	var try_load_image = _image.load(path)
	
	if try_load_image == OK:
		_image.load(path)
		var image_texture = ImageTexture.new()
		image_texture.set_image(_image)
		$Control/QuizImage.texture = image_texture
		$ImageImportGroup.visible = false
	else :
		$ImageImportGroup/ErrorMsg.text = "Nem megfelelő fájltípus!"

#=====SAVING THE QUIZ=====
