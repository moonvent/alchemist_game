extends Node2D

class_name TargetFollowBehavior

var vision_range: int
var vision_angle: float = 60

var has_seen_target: bool = false

var _target: CharacterBody2D
var _main_node: CharacterBody2D

# see only in up
var forward_vector: Vector2 = Vector2.UP

var _vision_zone_node: Node2D

var _last_seen_position: Vector2 = Vector2.ZERO

var _follow_direction: Vector2 = Vector2.ZERO


class FollowResult:
	"Object is following result

	Attributes:
		direction(Vector2): where the target
		last_seen_position(Vector2): last seen position of target
		is_lost_target(bool): if lost target it's true"

	var direction: Vector2
	var last_seen_position: Vector2
	var is_lost_target: bool

	func _init(_direction: Vector2, _last_seen_position: Vector2, _is_lost_target: bool) -> void:
		direction = _direction
		last_seen_position = _last_seen_position
		is_lost_target = _is_lost_target


func _init(
	target: CharacterBody2D,
	main_node: CharacterBody2D,
	_vision_range: int,
	_vision_angle: int,
) -> void:
	_target = target
	_main_node = main_node
	vision_range = _vision_range
	vision_angle = _vision_angle


func _ready() -> void:
	_vision_zone_node = VisionZone.new()
	add_child(_vision_zone_node)


func follow():
	var is_lost_target = false

	if can_see_target():
		_last_seen_position = _target.global_position
		_follow_direction = (_last_seen_position - _main_node.global_position).normalized()
		has_seen_target = true
		forward_vector = _follow_direction
		_vision_zone_node.redraw(_follow_direction)

	elif has_seen_target:
		_follow_direction = (_last_seen_position - _main_node.global_position).normalized()

		if _main_node.global_position.distance_to(_last_seen_position) < 10:
			# pause following if near last seen point
			has_seen_target = false

		is_lost_target = true

	else:
		_follow_direction = Vector2.ZERO
		is_lost_target = true

	return FollowResult.new(_follow_direction, _last_seen_position, is_lost_target)


func can_see_target() -> bool:
	if _main_node.global_position.distance_to(_target.global_position) > vision_range:
		return false

	var to_target = (_target.global_position - _main_node.global_position).normalized()

	var angle_to_player = forward_vector.angle_to(to_target)

	if abs(rad_to_deg(angle_to_player)) <= vision_angle:
		return true

	return false
