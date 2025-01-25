extends Node



func _on_button_pressed() -> void:
	$ImageImportGroup/FileDialog.popup()




func _on_file_dialog_file_selected(path: String) -> void:
	_load_image(path)



func _load_image(path: String):
	var image = Image.new()
	var try_load_image = image.load(path)
	
	if try_load_image == OK:
		image.load(path)
		var image_texture = ImageTexture.new()
		image_texture.set_image(image)
		$QuizImage.texture = image_texture
		$ImageImportGroup.visible = false
	else :
		$ImageImportGroup/ErrorMsg.text = "Nem megfelelő fájltípus!"
