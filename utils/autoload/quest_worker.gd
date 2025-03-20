extends Node

# active quests storage
var active_quests: Dictionary[String, Quest] = {}
# quests storage
var quests_map: Dictionary[String, Quest] = {}


func _ready() -> void:
	_load_all_quests_from_file()


func add_quest(param: DialogParamWorker):
	active_quests[param.param_name] = quests_map[param.param_name]


func remove_quest():
	pass


func complete_quest(param: DialogParamWorker):
	active_quests.erase(param.param_name)


func get_quest_list():
	pass


func update_quest(quest: Quest, update_quest_event: WorldListenerCore.QuestEvent):
	pass


func emit_event(event: WorldListenerCore.WorldEvent):
	var quest: Quest

	for quest_name in active_quests:
		quest = active_quests[quest_name]
		for condition_to_complete in quest.conditions_to_complete:
			if condition_to_complete.param_name == event.name:
				for action in quest.actions_to_complete:
					if condition_to_complete.param_name == action.action_name:
						if (
							event.from == action.from
							and (action.target == "any" or (action.target == event.target))
						):
							if (
								event.event_operation
								== WorldListenerCore.WorldEventOperation.FloatAdd
							):
								quest.current_progression = str(
									float(event.value) + float(quest.current_progression)
								)
								if quest.current_progression == condition_to_complete.param_value:
									complete_quest_step(quest)


func complete_quest_step(quest: Quest):
	# think about it, maybe we need to do it in Quest object
	print("quest_step_complete")


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
					_parse_conditions(quest_info.get("conditions_to_complete", [])),
					_parse_actions(quest_info.get("actions_to_complete", []))
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


func _parse_actions(actions_array: Array) -> Array:
	var conditions_parsed: Array = []
	for condition in actions_array:
		(
			conditions_parsed
			. append(
				{
					"action_name": condition["action_name"],
					"target": condition.get("target", ""),
					"from": condition.get("from", ""),
				}
			)
		)
	return conditions_parsed
