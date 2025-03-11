extends Node

# quests storage
var active_quests: Array[Quest] = []
var quests_map: Dictionary[String, Quest] = {}


func _ready() -> void:
	_load_all_quests_from_file()


func add_quest(param: DialogParamWorker):
	active_quests.append(quests_map[param.param_name])
	print(active_quests)


func remove_quest():
	pass


func get_quest_list():
	pass


func _load_all_quests_from_file():
	var file = FileAccess.open("res://quests/quests.json", FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		var quests_data = JSON.parse_string(json_text)

		if typeof(quests_data) == TYPE_DICTIONARY:
			for quest_key in quests_data.keys():
				var quest_info = quests_data[quest_key]
				var quest = Quest.new(
					quest_key,
					quest_info.get("name", ""),
					quest_info.get("goal", ""),
					_parse_conditions(quest_info.get("conditions_to_complete", []))
				)
				quests_map[quest_key] = quest

		else:
			push_error("Invalid quests data format.")

	else:
		push_error("Failed to open quests.json.")


func _parse_conditions(conditions_array: Array) -> Array:
	var conditions_parsed: Array = []
	for condition in conditions_array:
		conditions_parsed.append(
			{
				"param_name": condition["param_name"],
				"param_value": condition["param_value"],
				"param_type": DialogParamWorker.ParamType[condition["param_type"]]
			}
		)
	return conditions_parsed
