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
		for conditions_to_complete in quest.steps[quest.current_step_number].conditions_to_complete:
			if conditions_to_complete.ctype == event.name:
				for action in conditions_to_complete.actions_to_complete:
					if (
						action.from == event.from
						and (action.target == "any" or (action.target == event.target))
					):
						if (
							conditions_to_complete.operation
							== WorldListenerCore.WorldEventOperation.FloatAdd
						):
							quest.current_progression = str(
								float(event.value) + float(quest.current_progression)
							)
							if quest.current_progression == conditions_to_complete.value:
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
					_parse_steps(quest_info.get("steps", []))
				)
				quests_map[quest_key] = quest

		else:
			push_error("Invalid quests data format.")

	else:
		push_error("Failed to open quests.json.")


func _parse_steps(steps: Array) -> Array[Quest.Step]:
	var result_array: Array[Quest.Step] = []
	var actions_to_complete: Array[Quest.ActionToComplete]
	var conditions_to_complete: Array[Quest.ConditionToComplete]
	var step: Quest.Step

	for json_step in steps:
		conditions_to_complete = []
		for condition in json_step["conditions_to_complete"]:
			actions_to_complete = []
			for action in condition["actions_to_complete"]:
				actions_to_complete.append(
					Quest.ActionToComplete.new(action.get("target", ""), action.get("from", ""))
				)
			conditions_to_complete.append(
				Quest.ConditionToComplete.new(
					condition["readable_name"],
					WorldListenerCore.WorldEventName[condition["ctype"]],
					condition["value"],
					Quest.ProgressOperation[condition["operation"]],
					actions_to_complete
				)
			)
		step = Quest.Step.new(conditions_to_complete)
		result_array.append(step)

	return result_array
