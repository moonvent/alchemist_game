extends "res://character/base_character.gd"

var vision_range: float = 100
var last_seen_position: Vector2 = Vector2.ZERO
var player: Node2D = null
var has_seen_player: bool = false
var vision_angle: float = 60

# see only in up
var forward_vector: Vector2 = Vector2.UP

var vision_zone_node: Node2D


func _ready():
	SPEED = 0  # only for test
	player = get_node_or_null("../MainCharacter")
	assert(player != null, "Player node not found! Check the path.")
	vision_zone_node = get_node("VisionZone")

	super._ready()
	set_collision_layer(2)
	set_collision_mask(1)

	_setup_attack_collisions(4, 1)


func _physics_process(delta):
	if not player:
		return

	var direction = Vector2.ZERO

	if can_see_player():
		last_seen_position = player.global_position
		direction = (last_seen_position - global_position).normalized()
		has_seen_player = true
		forward_vector = direction

	elif has_seen_player:
		direction = (last_seen_position - global_position).normalized()

		if global_position.distance_to(last_seen_position) < 10:
			has_seen_player = false

	if global_position.distance_to(last_seen_position) < 20:
		_start_attack(last_seen_position)

	velocity = direction * SPEED
	_play_run_sprite_animation(direction)
	move_and_slide()


func can_see_player() -> bool:
	if global_position.distance_to(player.global_position) > vision_range:
		return false

	var to_player = (player.global_position - global_position).normalized()

	var angle_to_player = forward_vector.angle_to(to_player)

	if abs(rad_to_deg(angle_to_player)) <= vision_angle:
		vision_zone_node.redraw(to_player)
		return true
	return false
