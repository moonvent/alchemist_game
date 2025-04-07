extends Spell

class_name LineSpell

var _increase_direction: Vector2
var _point_offset: Vector2
var _projected_point: Vector2

var _base_projectile_points: PackedVector2Array
var _origin_point: Vector2
var _new_polygon_points: Array[Vector2]

var _increase_size_speed = 3.0
var _projectile_lifetime = 0.5

var only_one_intance_in_time: bool = true

# this var need, because we need to increase only in one direction line
var first_point_setup_direction: Vector2

var collider: CollisionPolygon2D


func _ready() -> void:
	spell_name = "Line"
	base_damage = 1
	collider = $Spell/Area2D/CollisionPolygon2D
	super()


func _physics_process(delta):
	spell_node.look_at(get_global_mouse_position())

	_base_projectile_points = spell_node.polygon
	_origin_point = _base_projectile_points[0]
	_new_polygon_points = [_origin_point]

	for i in range(1, _base_projectile_points.size() - 1):
		if not first_point_setup_direction:
			_increase_direction = (_base_projectile_points[i] - _origin_point).normalized()
			first_point_setup_direction = _increase_direction
		else:
			_increase_direction = first_point_setup_direction

		_point_offset = _base_projectile_points[i] - _origin_point
		_projected_point = (
			_increase_direction * _point_offset.length() * (1 + _increase_size_speed * delta)
		)
		_new_polygon_points.append(_origin_point + _projected_point)

	_new_polygon_points.append(_base_projectile_points[-1])
	spell_node.polygon = _new_polygon_points
	collider.polygon = _new_polygon_points

	_increase_size_speed *= pow(2, delta)  # speedup in two times every one frame

	_projectile_lifetime -= delta
	if _projectile_lifetime <= 0:
		can_use_spell = true
		queue_free()
	elif only_one_intance_in_time:
		can_use_spell = false


func add_damage_signal(player_signal_function: Callable):
	(
		spell_node
		. get_node("Area2D")
		. connect(
			"body_entered",
			player_signal_function.bind(base_damage),
		)
	)
