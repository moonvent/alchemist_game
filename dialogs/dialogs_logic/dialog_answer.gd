# Dialog answer it's class need for preview the answer and handle
# answer logic by change some params after select specify answer

class_name DialogAnswer

var answer_id: int
var text: String
var prize_for_select_answer: Array[DialogAttributeSetter]
var conditions_for_availability: Array[DialogAnswerCondition]
var player: Player

var is_available: bool:
	get:
		return _is_answer_available()


func _init(_player: Player):
	player = _player


func _is_answer_available() -> bool:
	for condition in conditions_for_availability:
		var handler: Callable
		var entity: BaseCharacter
		# var for hander
		var get_body: Dictionary = {}

		match condition.condition_type:
			DialogAnswerCondition.ConditionType.Attribute:
				handler = _get_attribute

		# if we want to check it in npc, we need condition name starts from 'npc__'
		if condition.condition_name.begins_with("npc__"):
			pass

		else:
			entity = player
			get_body["attribute_name"] = condition.condition_name
			get_body["attribute_value"] = condition.condition_value

		if not handler.call(entity, get_body):
			return false

	return true


# TODO: add more type hintings
func _get_attribute(get_entity: BaseCharacter, get_body: Dictionary):
	var condition_value = get_entity.conditions.get(get_body["attribute_name"])
	if condition_value:
		return condition_value == get_body["attribute_value"]
	return false


func set_param_after_chose_answer():
	for set_param in prize_for_select_answer:
		var handler: Callable
		var entity: BaseCharacter
		# var for hander
		var get_body: Dictionary = {}

		match set_param.attribute_type:
			DialogAttributeSetter.AttributeType.Attribute:
				handler = set_attribute

		if set_param.attribute_name.begins_with("npc__"):
			pass

		else:
			entity = player
			get_body["attribute_name"] = set_param.attribute_name
			get_body["attribute_value"] = set_param.attribute_value

		handler.call(entity, get_body)


func set_attribute(set_entity: BaseCharacter, set_body: Dictionary):
	# var condition_value = get_entity.conditions.get(get_body["attribute_name"])
	# if condition_value:
	# 	return condition_value == get_body["attribute_value"]
	# return false
	print(set_entity, set_body)
	pass
