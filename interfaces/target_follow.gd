extends Node2D

class_name TargetFollowBehavior

var vision_range: int
var vision_angle: float = 60

var has_seen_target: bool = false

var _target: CharacterBody2D = null
var _main_node: CharacterBody2D

# see only in up
var forward_vector: Vector2 = Vector2.UP

var _last_seen_position: Vector2 = Vector2.ZERO

var _follow_direction: Vector2 = Vector2.ZERO

var _vision_zone_area: Area2D


class FollowResult:
	"Object is following result

	Attributes:
		direction(Vector2): where the target
		last_seen_position(Vector2): last seen position of target
		is_lost_target(bool): if lost target it's true"

	var direction: Vector2
	var last_seen_position: Vector2
	var is_lost_target: bool
	var distance_to_target: float

	func _init(_direction: Vector2, _last_seen_position: Vector2, _is_lost_target: bool, _distance_to_target: float) -> void:
		direction = _direction
		last_seen_position = _last_seen_position
		is_lost_target = _is_lost_target
		distance_to_target = _distance_to_target


func _init(
	main_node: CharacterBody2D,
	_vision_range: int,
	_vision_angle: int,
) -> void:
	_main_node = main_node
	vision_range = _vision_range
	vision_angle = _vision_angle


func _ready() -> void:
	_vision_zone_area = get_parent().get_node('VisionZoneArea2D')
	_vision_zone_area.connect('body_entered', _on_body_entered_in_vision_zone)
	_vision_zone_area.connect('body_exited', _on_body_exited_from_vision_zone)


func _on_body_entered_in_vision_zone(body):
	if body != _main_node and not _target:
		_target = body


func _on_body_exited_from_vision_zone(body):
	if body != _main_node and _target:
		_target = null


func follow():

	var is_lost_target = false
	var distance_to_target = 0

	if can_see_target():
		_last_seen_position = _target.global_position
		var follow_not_normalized_direction = _last_seen_position - _main_node.global_position
		_follow_direction = follow_not_normalized_direction.normalized()
		has_seen_target = true
		forward_vector = _follow_direction
		_vision_zone_area.rotation = atan2(-follow_not_normalized_direction.y, -follow_not_normalized_direction.x)
		distance_to_target = follow_not_normalized_direction.length()

	elif has_seen_target:
		_follow_direction = (_last_seen_position - _main_node.global_position).normalized()

		if _main_node.global_position.distance_to(_last_seen_position) < 10:
			# pause following if near last seen point
			has_seen_target = false

		is_lost_target = true
		distance_to_target = (_last_seen_position - _main_node.global_position).length()

	else:
		_follow_direction = Vector2.ZERO
		is_lost_target = true

	return FollowResult.new(_follow_direction, _last_seen_position, is_lost_target, distance_to_target)


func can_see_target() -> bool:
	return true if _target else false
