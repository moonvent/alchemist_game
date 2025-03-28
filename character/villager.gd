extends "res://character/npc.gd"


func _ready():
	target_follow_behavior = TargetFollowBehavior.new(self, false)

	load_dialog("dialogs/dialog_lines_jsons/%s.json" % self.name)
	conditions["first_look"] = true

	add_child(target_follow_behavior)
	super._ready()


func make_damage(damage: float, who: CharacterBody2D):
	super.make_damage(damage, who)
	_target = who


func _move_mechanic():
	var follow_object: TargetFollowBehavior.FollowResult = target_follow_behavior.follow(_target)

	if not follow_object.is_lost_target:
		if follow_object.distance_to_target > 0 and follow_object.distance_to_target < attack_range:
			_start_attack(follow_object.last_seen_position)

	velocity = (
		follow_object.direction
		* AttributeWorker.get_attribute_value(name, Attribute.AttributeName.MoveSpeed)
	)

	_play_run_sprite_animation(follow_object.direction)
	move_and_slide()
