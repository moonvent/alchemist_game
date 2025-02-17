extends Node


func load_json_by_string(file_name: String) -> Dictionary:
	# TODO: add file existing check
	var file = FileAccess.open(
		"res://dialogs/dialog_lines_jsons/{file_name}.json".format({"file_name": file_name}),
		FileAccess.READ
	)

	var text = file.get_as_text()

	file.close()

	var result = JSON.parse_string(text)

	return result
