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
var current_progression: Dictionary
var current_step_number: int
var steps: Array[Step]
var current_step: Step


func _init(_quest_id: String, _name: String, _goal: String, _steps: Array[Step]):
	self.quest_id = _quest_id
	self.name = _name
	self.goal = _goal
	self.current_progression = {}
	self.steps = _steps

	if _steps.size() > 0:
		self.current_step_number = 0
		self.current_step = _steps[current_step_number]


func switch_to_next_step():
	current_step_number += 1
	if current_step_number == steps.size():
		# change status of quest to complete
		print("Quest: '", name, "' is complete, but not changed status")
		pass


func update_quest_progression(event: WorldListenerCore.WorldEvent):
	for condition in current_step.conditions_to_complete:
		if condition.ctype != event.name:
			continue
		match event.name:
			WorldListenerCore.WorldEventName.DealDamage:
				_handle_deal_damage_event(event, condition)
			WorldListenerCore.WorldEventName.PlayerMove:
				_handle_player_move_event(event, condition)


func _handle_deal_damage_event(
	event: WorldListenerCore.DealDamageEvent, condition: ConditionToComplete
):
	for action in condition.actions_to_complete:
		if (
			action.from == event.from
			and (action.target == "any" or (action.target == event.target))
		):
			current_progression[event.name] = (
				float(event.value) + float(current_progression.get(event.name, 0))
			)

		if current_progression.get(event.name, 0) >= float(condition.value):
			switch_to_next_step()


func _handle_player_move_event(
	event: WorldListenerCore.PlayerMoveEvent, condition: ConditionToComplete
):
	current_progression[event.name] = (
		event.distance_in_pixels + current_progression.get(event.name, 0)
	)

	if current_progression.get(event.name, 0) >= float(condition.value):
		switch_to_next_step()
