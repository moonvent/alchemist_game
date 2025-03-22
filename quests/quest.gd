class_name Quest

enum ProgressOperation { Add, Minus, Multiply, Divide, IntAdd, FloatAdd }


class ActionToComplete:
	# optional vars
	var target: String = ""
	var from: String = ""

	func _init(_target: String = "", _from: String = ""):
		target = _target
		from = _from


class ConditionToComplete:
	var readable_name: String
	var ctype: WorldListenerCore.WorldEventName
	var value: String
	var operation: ProgressOperation
	var actions_to_complete: Array[ActionToComplete]

	func _init(
		_readable_name: String,
		_ctype: WorldListenerCore.WorldEventName,
		_value: String,
		_operation: ProgressOperation,
		_actions_to_complete: Array[ActionToComplete]
	):
		readable_name = _readable_name
		ctype = _ctype
		value = _value
		operation = _operation
		actions_to_complete = _actions_to_complete


class Step:
	var conditions_to_complete: Array[ConditionToComplete]

	func _init(_conditions_to_complete: Array[ConditionToComplete]):
		conditions_to_complete = _conditions_to_complete


var quest_id: String
var name: String  # just name of quest for player
var goal: String  # just goal of quest for player
var current_progression: String
var current_step_number: int
var steps: Array[Step]


func _init(_quest_id: String, _name: String, _goal: String, _steps: Array[Step]):
	self.quest_id = _quest_id
	self.name = _name
	self.goal = _goal
	self.current_progression = ""
	self.steps = _steps
	self.current_step_number = 0


func switch_to_next_step():
	print("sex")


func update_quest_progression(event: WorldListenerCore.WorldEvent):
	for conditions_to_complete in steps[current_step_number].conditions_to_complete:
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
						current_progression = str(float(event.value) + float(current_progression))
						if current_progression == conditions_to_complete.value:
							switch_to_next_step()
