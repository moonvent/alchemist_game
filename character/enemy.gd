extends "res://character/npc.gd"


func _ready():
	target_follow_behavior = TargetFollowBehavior.new(self, vision_range, vision_angle)
	add_child(target_follow_behavior)

	super._ready()


func _physics_process(delta):
	var follow_object: TargetFollowBehavior.FollowResult = target_follow_behavior.follow()

	if (
		not follow_object.is_lost_target
		and global_position.distance_to(follow_object.last_seen_position) < 10
	):
		_start_attack(follow_object.last_seen_position)

	velocity = follow_object.direction * SPEED
	_play_run_sprite_animation(follow_object.direction)
	move_and_slide()
