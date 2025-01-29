extends Control

class_name DialogWindow

var current_dialog_line: Dictionary  # it's a value ID in DIALOG_LINES
var current_dialog_npc: CharacterBody2D  # it's npc which has dialog with us


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TranslationServer.set_locale("en")
	for replica_option in $DialogElements/ReplicaOptions.get_children():
		replica_option.pressed.connect(func(): _replica_handler(replica_option))


func start_new_dialog(npc: CharacterBody2D, replica_number: int):
	self.visible = true

	current_dialog_line = npc.dialog_lines["lines"][str(replica_number)]
	current_dialog_npc = npc
	var npc_dialog_conditions = current_dialog_line["conditions_for_line"]

	for condition in npc_dialog_conditions:
		if npc.conditions[condition] != npc_dialog_conditions[condition]:
			return

	$DialogElements/ReplicaOwnerName.text = tr(npc.name)

	var npc_replica_text_code = npc.name + "__" + str(current_dialog_line.id)
	$DialogElements/ReplicaText.text = tr(npc_replica_text_code)

	var available_answers = current_dialog_line["available_answers"]

	var replica_option: Button
	var answer_id: int

	var answer: Dictionary

	var skip_answer_from_condition: bool = false

	for awailable_answer_index in range(available_answers.size()):
		answer = available_answers[awailable_answer_index]

		for condition in answer.get("conditions_for_answer", []):
			if npc.conditions[condition] != answer["conditions_for_answer"][condition]:
				skip_answer_from_condition = true
				continue

		if skip_answer_from_condition:
			skip_answer_from_condition = false
			continue

		replica_option = $DialogElements/ReplicaOptions.get_node(
			"ReplicaOption" + str(awailable_answer_index)
		)
		replica_option.visible = true
		answer_id = answer.id

		replica_option.text = tr(npc_replica_text_code + "__" + str(answer_id))

		replica_option.set_meta("answer_index", awailable_answer_index)
		print(replica_option.text)


func deactivate_dialog():
	self.visible = false
	$DialogElements/ReplicaOwnerName.text = ""
	$DialogElements/ReplicaText.text = ""
	for i in range(4):
		$DialogElements/ReplicaOptions.get_node("ReplicaOption" + str(i)).visible = false


func _replica_handler(button):
	var answer = current_dialog_line["available_answers"][int(button.get_meta("answer_index"))]
	var conditions_after_line = answer["conditions_after_line"]

	for condition in conditions_after_line:
		current_dialog_npc["conditions"][condition] = conditions_after_line[condition]
