class_name DialogReplica

var id: int
var npc: BaseCharacter
var player: Player
var npc_name: String
var text: String

# all answers available in replica
var available_answers: Array[DialogAnswer]

# only this we need to call, not upper param
var available_to_display_answers_list:
	get:
		return _get_available_to_display_answers_list()


func _init(_player: Player):
	player = _player


func _get_available_to_display_answers_list() -> Array:
	var available_to_display_answers = []

	for answer in available_answers:
		if answer.is_answer_available(npc):
			available_to_display_answers.append(answer)

	return available_to_display_answers
