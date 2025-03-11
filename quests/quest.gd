class_name Quest

var quest_id: String
var name: String  # just name of quest for player
var goal: String  # just goal of quest for player
var conditions_to_complete: Array


func _init(quest_id: String, name: String, goal: String, conditions_to_complete: Array):
	self.quest_id = quest_id
	self.name = name
	self.goal = goal
	self.conditions_to_complete = conditions_to_complete
