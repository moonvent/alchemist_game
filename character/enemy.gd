extends "res://character/npc.gd"


func _ready():
	target_follow_behavior = TargetFollowBehavior.new(self, true)
	add_child(target_follow_behavior)

	super._ready()


func _physics_process(delta):
	var follow_object: TargetFollowBehavior.FollowResult = target_follow_behavior.follow()

	velocity = follow_object.direction * SPEED

	if not follow_object.is_lost_target:
		if follow_object.distance_to_target < attack_range:
			_start_attack(follow_object.last_seen_position)
			velocity = follow_object.direction * 0

	_play_run_sprite_animation(follow_object.direction)
	move_and_slide()
