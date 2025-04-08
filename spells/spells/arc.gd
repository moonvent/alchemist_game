extends Spell

class_name ArcSpell

var _increase_direction: Vector2
var _point_offset: Vector2
var _projected_point: Vector2

var _base_projectile_points: PackedVector2Array
var _origin_point: Vector2
var _new_polygon_points: Array[Vector2]

var _increase_size_speed = 2.0
var _projectile_lifetime = 0.5

var collider: CollisionPolygon2D


func _ready() -> void:
	spell_name = "Arc"
	base_damage = 1
	collider = $Spell/Area2D/CollisionPolygon2D
	super()


func _startup_mixins():
	_spell_mixin_one_instance_in_time()


func _process_mixins_before():
	_process_spell_mixin_look_at()


func _physics_process(delta):
	_process_mixins_before()

	_base_projectile_points = spell_node.polygon
	_origin_point = _base_projectile_points[0]
	_new_polygon_points = [_origin_point]

	for i in range(1, _base_projectile_points.size()):
		_increase_direction = (_base_projectile_points[i] - _origin_point).normalized()
		_point_offset = _base_projectile_points[i] - _origin_point
		_projected_point = (
			_increase_direction * _point_offset.length() * (1 + _increase_size_speed * delta)
		)
		_new_polygon_points.append(_origin_point + _projected_point)

	spell_node.polygon = _new_polygon_points
	collider.polygon = _new_polygon_points

	_increase_size_speed *= pow(2, delta)  # speedup in two times every one frame

	_projectile_lifetime -= delta
	if _projectile_lifetime <= 0:
		can_use_spell = true
		queue_free()


func add_damage_signal(player_signal_function: Callable):
	(
		spell_node
		. get_node("Area2D")
		. connect(
			"body_entered",
			player_signal_function.bind(base_damage),
		)
	)
