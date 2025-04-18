extends Node2D

class_name TargetFollowBehaviorMixin

var has_seen_target: bool = false

var _target: CharacterBody2D = null
var _main_node: CharacterBody2D  # it's a parent node, character body

# see only in up
var forward_vector: Vector2 = Vector2.UP

var _last_seen_position: Vector2 = Vector2.ZERO

var _follow_direction: Vector2 = Vector2.ZERO

var _vision_zone_area: Node2D

var _aggressive_mode: bool


class FollowResult:
	# Object is following result
	#
	# Attributes:
	# 	direction(Vector2): where the target
	# 	last_seen_position(Vector2): last seen position of target
	# 	is_lost_target(bool): if lost target its true

	var direction: Vector2
	var last_seen_position: Vector2
	var is_lost_target: bool
	var distance_to_target: float

	func _init(
		_direction: Vector2,
		_last_seen_position: Vector2,
		_is_lost_target: bool,
		_distance_to_target: float
	) -> void:
		direction = _direction
		last_seen_position = _last_seen_position
		is_lost_target = _is_lost_target
		distance_to_target = _distance_to_target


func _init(main_node: CharacterBody2D, aggressive_mode: bool) -> void:
	_main_node = main_node
	_aggressive_mode = aggressive_mode


func _ready() -> void:
	_vision_zone_area = get_parent().get_node("VisionRays")
	_vision_zone_area.set_main_node(_main_node)
	_vision_zone_area.switch_enable_status(_aggressive_mode)


func follow(target: CharacterBody2D = null):
	var is_lost_target = false
	var distance_to_target: float

	if _aggressive_mode or target:
		_target = can_see_target(target)

		if _target:
			_last_seen_position = _target.global_position
			var follow_not_normalized_direction = _last_seen_position - _main_node.global_position
			_follow_direction = follow_not_normalized_direction.normalized()
			has_seen_target = true
			_vision_zone_area.rotation = follow_not_normalized_direction.angle() + PI
			distance_to_target = follow_not_normalized_direction.length()

		elif has_seen_target:
			_follow_direction = (_last_seen_position - _main_node.global_position).normalized()

			if _main_node.global_position.distance_to(_last_seen_position) < 10:
				# pause following if near last seen point
				has_seen_target = false
				distance_to_target = -1

			else:
				distance_to_target = (_last_seen_position - _main_node.global_position).length()

			is_lost_target = true

		else:
			_follow_direction = Vector2.ZERO
			is_lost_target = true

	return FollowResult.new(
		_follow_direction, _last_seen_position, is_lost_target, distance_to_target
	)


func can_see_target(target: CharacterBody2D = null):
	if not _aggressive_mode:
		_aggressive_mode = true
		_vision_zone_area.switch_enable_status(true)

	return _vision_zone_area.scan_near_location(target)
