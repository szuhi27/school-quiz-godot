extends Node

func _ready() -> void:
	get_tree().get_root().files_dropped.connect(_on_files_dropped)

func  _on_files_dropped(files):
	var file = FileAccess.open(files[0], FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	var data = json.data
	var image = Image.new()
	image.load_jpg_from_buffer(data["image"].to_utf8_buffer())
	var image_texture = ImageTexture.new()
	image_texture.set_image(image)
	$Control/TextureRect.texture = image_texture
	#var byt = Marshalls.base64_to_raw(base64_string)
