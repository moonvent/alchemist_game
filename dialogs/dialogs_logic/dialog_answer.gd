# Dialog answer it's class need for preview the answer and handle
# answer logic by change some params after select specify answer

class_name DialogAnswer

var answer_id: int
var text: String
var prize_for_select_answer: Array[DialogParamWorker]
var conditions_for_availability: Array[DialogParamWorker]
var player: Player
var next: String


class NextType:
	const NewReplica = "new_replica"
	const Action = "action"
	const Out = "out"


func _init(_player: Player):
	player = _player


func is_answer_available(npc: BaseCharacter) -> bool:
	var character: BaseCharacter

	for condition in conditions_for_availability:
		character = npc if condition.param_name.begins_with("npc__") else player

		if (
			condition.param_value == "check__and__complete"
			and condition.is_check_condition(character)
		):
			return true
		elif not condition.is_check_condition(character):
			return false

	return true


func set_param_after_chose_answer(npc: BaseCharacter):
	var character: BaseCharacter

	for set_param in prize_for_select_answer:
		character = npc if set_param.param_name.begins_with("npc__") else player

		set_param.set_param(character)
