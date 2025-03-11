extends Node

var _image = Image
var _zipfile = ZIPPacker
var _image_name

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
		_image_name = path.get_file()
		$BubbleAdder.show()
	else :
		$ImageImportGroup/ErrorMsg.text = "Nem megfelelő fájltípus!"

#=====SAVING THE QUIZ=====

func _on_save_button_pressed() -> void:
	$SaveFileDialog.current_file = _image_name.get_slice(".",0)
	$SaveFileDialog.popup()

#this works, dir_select does not
func _on_save_file_dialog_file_selected(path: String) -> void:
	_save_quiz(path)

func _save_quiz(path: String):
	_zipfile = ZIPPacker.new()
	var err = _zipfile.open(path, _zipfile.APPEND_CREATE)
	if err != OK:
		return err
	_zipfile.start_file(_image_name)
	_zipfile.write_file(_image.get_data())
	_zipfile.close_file()
	_zipfile.close()
	
