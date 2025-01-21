extends Node


func load_json_by_npc_name(npc_name: String) -> Dictionary:
	# TODO: add file existing check
	var file = FileAccess.open(
		"res://dialogs/dialog_lines_jsons/{npc_name}.json".format({"npc_name": npc_name}),
		FileAccess.READ
	)

	var text = file.get_as_text()

	file.close()

	var result = JSON.parse_string(text)

	return result
