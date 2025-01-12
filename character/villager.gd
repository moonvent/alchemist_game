extends "res://character/npc.gd"


func _ready():
	target_follow_behavior = TargetFollowBehavior.new(self, false)
	add_child(target_follow_behavior)

	super._ready()
