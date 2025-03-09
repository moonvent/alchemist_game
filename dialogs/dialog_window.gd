extends Control

class_name DialogWindow

var current_dialog_replica: DialogReplica

var player: Player

var available_answers: Array[Button] = []

const MAX_AMOUNT_ANSWERS: int = 4


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TranslationServer.set_locale("en")
	player = get_parent().get_parent()
	for replica_option in $DialogElements/ReplicaOptions.get_children():
		replica_option.pressed.connect(func(): _answer_choise_handler(replica_option))


func start_new_dialog(npc: BaseCharacter, replica_number: int):
	player.conditions[npc.name + "__last_dialog_number"] = replica_number

	current_dialog_replica = npc.dialog_replicas[replica_number]
	current_dialog_replica.npc = npc
	_set_owner_name()
	_set_text()
	_set_answers()

	# it's need to be here, cause if we turn it visible immediatly,
	# system not able to process all answers in time
	if not self.visible:
		self.visible = true


func deactivate_dialog():
	if self.visible:
		self.visible = false
		$DialogElements/ReplicaOwnerName.text = ""
		$DialogElements/ReplicaText.text = ""
		_clear_available_answers()


func _answer_choise_handler(answer_button: Button):
	var answer: DialogAnswer = answer_button.get_meta("answer")
	answer.set_param_after_chose_answer(current_dialog_replica.npc)

	_handle_answer_next(answer.next)


func _set_owner_name():
	$DialogElements/ReplicaOwnerName.text = tr(current_dialog_replica.npc_name)


func _set_text():
	$DialogElements/ReplicaText.text = tr(current_dialog_replica.text)


func _clear_available_answers():
	# clear all ui buttons from previous dialog reploca state
	for replica_option in available_answers:
		replica_option.text = ""
		replica_option.remove_meta("answer")
		replica_option.visible = false

	available_answers.clear()


func _set_answers():
	_clear_available_answers()

	var answers = current_dialog_replica.available_to_display_answers_list

	for answer_index in range(len(answers)):
		var answer = answers[answer_index]
		var replica_option: Button = $DialogElements/ReplicaOptions.get_node(
			"ReplicaOption" + str(answer_index)
		)
		replica_option.visible = true

		replica_option.text = tr(answer.text)

		replica_option.set_meta("answer", answer)

		available_answers.append(replica_option)


func _handle_answer_next(next: String):
	var action: PackedStringArray = next.split("__")
	var action_type: String = action[0]

	match action_type:
		DialogAnswer.NextType.NewReplica:
			start_new_dialog(current_dialog_replica.npc, int(action[1]))
		DialogAnswer.NextType.Out:
			deactivate_dialog()


func _input(event):
	# TODO: think about some locking player for dialog
	if available_answers:
		var amount_available_answers := len(available_answers)

		if amount_available_answers and event.is_action_pressed("first_answer"):
			_answer_choise_handler(available_answers[0])
		elif amount_available_answers >= 2 and event.is_action_pressed("second_answer"):
			_answer_choise_handler(available_answers[1])
		elif amount_available_answers >= 3 and event.is_action_pressed("third_answer"):
			_answer_choise_handler(available_answers[2])
		elif amount_available_answers >= 4 and event.is_action_pressed("fourth_answer"):
			_answer_choise_handler(available_answers[3])
