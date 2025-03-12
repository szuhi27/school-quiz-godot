extends Node

var _image = Image
var _zipfile = ZIPPacker
var _image_name 
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
	_image = Image.new()
	var try_load_image = _image.load(path)
	
	if try_load_image == OK:
		_image.load(path)
		
		_image_data = _image.save_jpg_to_buffer() #get_buffer(_image.get_len())
		
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
	#_zipfile = ZIPPacker.new()
	#var err = _zipfile.open(path, _zipfile.APPEND_CREATE)
	#if err != OK:
		#return err
	#_zipfile.start_file(_image_name)
	#_zipfile.write_file(_image.get_data())
	#_zipfile.close_file()
	#_zipfile.close()
	
	var Im = Image.new()
	var base64_string = Marshalls.raw_to_base64(_image_data)
	var byt = Marshalls.base64_to_raw(base64_string)
	Im.load_jpg_from_buffer(byt)
	var image_texture = ImageTexture.new()
	image_texture.set_image(Im)
	$TestRect.texture = image_texture
	
	var json_data = {}
	#var imdat = _image.get_data()
	json_data["image"] = base64_string  # imdat
	
	var json = JSON.new()
	var json_string = json.stringify(json_data)
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(json_string)
	file.close()
	
	

#a képet is json ba mneteni, ezt az iinfo reszt, és akkor csak egy dilet kell létrehozni, próbáljuk
