extends "res://character/base_character.gd"


var vision_range: float = 100
var last_seen_position: Vector2 = Vector2.ZERO
var player: Node2D = null
var has_seen_player: bool = false
var vision_angle: float = 60


# see only in up
var forward_vector: Vector2 = Vector2.UP


func _ready():
	player = get_node_or_null("../MainCharacter")
	assert(player != null, "Player node not found! Check the path.")


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

	velocity = direction * SPEED
	_play_run_sprite_animation(direction)
	move_and_slide()

func can_see_player() -> bool:
	if global_position.distance_to(player.global_position) > vision_range:
		return false

	var to_player = (player.global_position - global_position).normalized()

	var angle_to_player = forward_vector.angle_to(to_player)

	return abs(rad_to_deg(angle_to_player)) <= vision_angle


func _draw():
	# draw_circle(Vector2.ZERO, vision_range, Color(0, 1, 0, 0.5))
	# var angle_start = forward_vector.angle() - deg_to_rad(vision_angle)
	# var angle_end = forward_vector.angle() + deg_to_rad(vision_angle)
	# draw_arc(
	# 	Vector2.ZERO, 
	# 	vision_range, 
	# 	angle_start,
	# 	angle_end,
	# 	50, 
	# 	Color(1, 1, 0, 0.9),
	# 	# vision_range
	# )
	var angle_start = forward_vector.angle() - deg_to_rad(vision_angle)
	var angle_end = forward_vector.angle() + deg_to_rad(vision_angle)
	var step = (angle_end - angle_start) / 50
	
	var points = [Vector2.ZERO]
	for i in range(51):
			var angle = angle_start + step * i
			points.append(Vector2(cos(angle), sin(angle)) * vision_range)
	
	draw_polygon(points, [Color(1, 0, 0, 0.5)])
