class_name Quest


class QuestActionToComplete:
	var action_name: String = ""

	# optional vars
	var target: String = ""
	var from: String = ""


var quest_id: String
var name: String  # just name of quest for player
var goal: String  # just goal of quest for player
var conditions_to_complete: Array
var actions_to_complete: Array
var current_progression: String


func _init(
	_quest_id: String,
	_name: String,
	_goal: String,
	_conditions_to_complete: Array,
	_actions_to_complete: Array
):
	self.quest_id = _quest_id
	self.name = _name
	self.goal = _goal
	self.conditions_to_complete = _conditions_to_complete
	self.actions_to_complete = _actions_to_complete
	self.current_progression = ""
