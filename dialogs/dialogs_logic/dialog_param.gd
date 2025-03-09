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

enum ParamOperation { Check, Set }


func is_check_condition(character: BaseCharacter) -> bool:
	return _param_manipulate(character, ParamOperation.Check)


func set_param(character: BaseCharacter) -> bool:
	return _param_manipulate(character, ParamOperation.Set)


func _param_manipulate(character: BaseCharacter, param_operation: ParamOperation):
	var handler: Callable

	match param_type:
		ParamType.Attribute:
			handler = _get_attribute if param_operation == ParamOperation.Check else _set_attribute
		ParamType.Quest:
			handler = _get_quest if param_operation == ParamOperation.Check else _set_quest

	return handler.call(character)


func _get_attribute(character: BaseCharacter):
	var condition_value = character.conditions.get(param_name)
	if condition_value:
		return condition_value == param_value
	return false


func _set_attribute(character: BaseCharacter):
	character.conditions[param_name] = param_value
	return true


func _get_quest(character: BaseCharacter):
	var condition_value = character.conditions.get(param_name)
	if condition_value:
		return condition_value == param_value
	return false


func _set_quest(character: BaseCharacter):
	QuestWorker.add_quest(self)
	return true
