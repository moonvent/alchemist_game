extends Node

var aspects: Dictionary[String, AspectElement] = {}


func _ready():
	_load_aspects_from_file()


func _load_aspects_from_file():
	var file = FileAccess.open("res://jsons/alchemy/aspects/elements.json", FileAccess.READ)
	if not file:
		push_error("Failed to open JSON file.")
		return

	var json_text = file.get_as_text()
	file.close()

	var json = JSON.parse_string(json_text)

	if json is Dictionary:
		for aspect_name in json.keys():
			var data = json[aspect_name]
			var element = AspectElement.new()

			element.name = aspect_name.capitalize()
			element.picture = _load_aspect_picture(aspect_name)

			element.damage = data["damage"]
			element.level = data["level"]
			element.radius = 6 - element.level

			element.one_part_name = data.get("one_part", "")
			element.second_part_name = data.get("second_part", "")

			aspects[aspect_name] = element
	else:
		push_error("JSON data is invalid.")


func _load_aspect_picture(name: String) -> String:
	# # временно возвращаем спрайт просто с именем, далее тут будет загрузка
	# var sprite = Sprite2D.new()
	# sprite.name = name
	# return sprite

	return name
