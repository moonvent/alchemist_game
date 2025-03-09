class_name Quest

var name: String  # just name of quest for player
var goal: String  # just goal of quest for player
var conditions_to_complete: Array


func _init(name: String, goal: String, conditions_to_complete: Array):
	self.name = name
	self.goal = goal
	self.conditions_to_complete = conditions_to_complete
