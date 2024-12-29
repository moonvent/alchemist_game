extends "res://character/npc.gd"

var player: Node2D = null


func _ready():
	player = get_node_or_null("../MainCharacter")
	assert(player != null, "Player node not found! Check the path.")

	target_follow_behavior = TargetFollowBehavior.new(player, self, vision_range, vision_angle)
	add_child(target_follow_behavior)

	super._ready()


func _physics_process(delta):
	if not player:
		return

	var follow_object: TargetFollowBehavior.FollowResult = target_follow_behavior.follow()

	if global_position.distance_to(follow_object.last_seen_position) < 20:
		_start_attack(follow_object.last_seen_position)

	velocity = follow_object.direction * SPEED
	_play_run_sprite_animation(follow_object.direction)
	move_and_slide()
