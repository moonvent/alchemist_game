extends "res://character/base_character.gd"

class_name NPC

var vision_range: int = 100
var vision_angle: float = 60
var attack_range: int = 15

var player: Player

var _target: CharacterBody2D

# see only in up
var forward_vector: Vector2 = Vector2.UP

var vision_zone_node: Node2D

var target_follow_behavior: TargetFollowBehavior


func _ready():
	player = get_node("%Player")
	super._ready()
	$DialogAreaTrigger.connect("body_entered", activate_dialog_hover)
	$DialogAreaTrigger.connect("body_exited", deactivate_dialog_hover)
	AttributeWorker.set_attribute_value(name, Attribute.AttributeName.MoveSpeed, 20)


func activate_dialog_hover(body):
	if body == player:
		$DialogAvailable.visible = true
		player.dialog_npc = self
		return true


func deactivate_dialog_hover(body):
	if body == player:
		$DialogAvailable.visible = false
		body.deactivate_dialog()
		player.dialog_npc = null
		return true


# Load dialogs from a JSON file
func load_dialog(file_path: String):
	# Open the JSON file
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		push_error("❌ Failed to open dialog file: " + file_path)
		return

	# Read the file content as text
	var content = file.get_as_text()
	var json = JSON.parse_string(content)

	if json == null:
		push_error("❌ Failed to parse JSON: " + file_path)
		assert(json, "Error parse json: " + file_path)
		return

	# Clear the previous dialogs
	dialog_replicas.clear()

	# Parse each replica from JSON
	for replica_data in json.get("replicas", []):
		var replica = DialogReplica.new(get_node("%Player"))
		replica.id = replica_data.get("id", 0)
		replica.npc_name = replica_data.get("npc_name", "")
		replica.text = replica_data.get("text", "")
		replica.npc = self

		# Load the available answers for this replica
		for answer_data in replica_data.get("answers", []):
			var answer = DialogAnswer.new(get_node("%Player"))
			answer.answer_id = answer_data.get("answer_id", 0)
			answer.text = answer_data.get("text", "")
			answer.next = answer_data.get("next", "out")

			# Load selection parameters for this answer
			for param_data in answer_data.get("select_params", []):
				var param = DialogParamWorker.new()
				param.param_name = param_data["param_name"]
				param.param_value = param_data["param_value"]

				# Convert string param_type to enum
				var param_type_str = param_data["param_type"]
				if param_type_str in DialogParamWorker.ParamType:
					param.param_type = DialogParamWorker.ParamType[param_type_str]
				else:
					param.param_type = DialogParamWorker.ParamType.Attribute

				answer.prize_for_select_answer.append(param)

			# Load conditions for answer availability
			for cond_data in answer_data["conditions"]:
				var condition = DialogParamWorker.new()
				condition.param_name = cond_data["condition_name"]
				condition.param_value = cond_data["condition_value"]

				# Convert string condition_type to enum
				var cond_type_str = cond_data["condition_type"]
				if cond_type_str in DialogParamWorker.ParamType:
					condition.param_type = DialogParamWorker.ParamType[cond_type_str]
				else:
					condition.param_type = DialogParamWorker.ParamType.Attribute

				answer.conditions_for_availability.append(condition)

			replica.available_answers.append(answer)

		# Add the fully populated replica to the list
		dialog_replicas[replica.id] = replica


func _physics_process(delta):
	_move_mechanic()


func _move_mechanic():
	pass
