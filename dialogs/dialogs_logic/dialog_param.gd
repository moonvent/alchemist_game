# Dialog param it's a param for selected dialog answer, for example, if
# player select: i'm ready to quest, we take him a item, or something else
# and this class will contain:
# param_name "Give Torch"
# param_value "Torch"
# param_type ParamType.Item

# TODO: add set attr, get item, get quest, set item, set quest

class_name DialogParamWorker

enum ParamType { Item, Quest, Attribute, WorldState }

var param_name: String
var param_value: String
var param_type: ParamType

enum ParamOperation { Check, Set, CheckAndComplete, Complete }


func is_check_condition(character: BaseCharacter) -> bool:
	return _param_manipulate(character, ParamOperation.Check)


func set_param(character: BaseCharacter) -> bool:
	var action: ParamOperation = ParamOperation.Set

	if param_type == ParamType.Quest:
		if param_value == "complete":
			action = ParamOperation.Complete

	return _param_manipulate(character, action)


func _param_manipulate(character: BaseCharacter, param_operation: ParamOperation):
	var handler: Callable

	match param_type:
		ParamType.Attribute:
			handler = _get_attribute if param_operation == ParamOperation.Check else _set_attribute

		ParamType.Quest:
			match param_operation:
				ParamOperation.Check:
					return param_name in QuestWorker.active_quests
				ParamOperation.Set:
					QuestWorker.add_quest(self)
					return true
				ParamOperation.Complete:
					QuestWorker.complete_quest(self)
					return true
				_:
					return false

	return handler.call(character)


func _get_attribute(character: BaseCharacter):
	var condition_value = character.conditions.get(param_name)
	if condition_value:
		return condition_value == param_value
	return false


func _set_attribute(character: BaseCharacter):
	character.conditions[param_name] = param_value
	return true
