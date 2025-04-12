extends Node

var aspects: Dictionary[String, AspectElement] = {}
var creation_map: Dictionary[Array, AspectElement] = {}


func _ready():
	_load_aspects_from_file()
	_create_creation_map()
	_connect_childs_to_parents()


func _create_creation_map():
	var generated_aspect: AspectElement
	var first_elem_name: String
	var second_elem_name: String
	for aspect in aspects:
		generated_aspect = aspects[aspect]

		if generated_aspect.one_part_name:
			first_elem_name = aspects[generated_aspect.one_part_name].name
			second_elem_name = aspects[generated_aspect.second_part_name].name
			creation_map[[first_elem_name, second_elem_name]] = generated_aspect


func _connect_childs_to_parents():
	for aspect_name in aspects:
		for parent_aspect_name in aspects[aspect_name].parent_elements:
			aspects[parent_aspect_name].child_elements.append(aspect_name)


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

			if element.one_part_name:
				element.parent_elements.append(element.one_part_name)
				element.parent_elements.append(element.second_part_name)

			aspects[aspect_name] = element

	else:
		push_error("JSON data is invalid.")


func _load_aspect_picture(name: String) -> String:
	# # временно возвращаем спрайт просто с именем, далее тут будет загрузка
	# var sprite = Sprite2D.new()
	# sprite.name = name
	# return sprite

	return name


func _load_researches_from_file():
	pass
