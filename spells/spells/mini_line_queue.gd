extends Spell

class_name MiniLineQueueSpell

var collider: CollisionPolygon2D

var _new_polygon: Polygon2D

var _projectile_speed = 100


var _direction_mouse_pos: Vector2
var _projectile_direction: Vector2

var _projectile_lifetime = 1

var _current_projectile_list: Array
var _timer_for_create_new_projetiles: Timer
var _time_for_create_new_projectiles: float = 0.2  # in seconds

var _default_projectiles_amount: int = 3
var _initial_object: Polygon2D
var _player_node: Player

var _player_location: Node2D

var _additional_projectiles_data: Dictionary[Polygon2D, _AdditionalProjectileData] = {}

var _cached_player_signal_function: Callable


class _AdditionalProjectileData:
	var direction: Vector2

	func _init(direction_mouse_pos: Vector2, current_global_position: Vector2):
		direction = (direction_mouse_pos - current_global_position).normalized()


func _ready() -> void:
	spell_name = "MiniLineQueue"
	base_damage = 0.35
	collider = $Spell/Area2D/CollisionPolygon2D
	super()

	_process_spell_mixin_look_at()
	_direction_mouse_pos = get_global_mouse_position()

	_initial_object = spell_node.duplicate()

	_player_node = find_parent("Player")
	_player_location = _player_node.get_parent()
	spell_node.reparent(_player_location)
	_additional_projectiles_data[spell_node as Polygon2D] = _AdditionalProjectileData.new(
		_direction_mouse_pos, _player_node.global_position
	)
	_current_projectile_list = [spell_node]

	_add_create_projectile_timer()


func _add_create_projectile_timer():
	_timer_for_create_new_projetiles = Timer.new()
	_timer_for_create_new_projetiles.wait_time = _time_for_create_new_projectiles
	_timer_for_create_new_projetiles.autostart = true
	_timer_for_create_new_projetiles.one_shot = false
	_timer_for_create_new_projetiles.timeout.connect(_init_additional_projectile)
	add_child(_timer_for_create_new_projetiles)


func _startup_mixins():
	_spell_mixin_one_instance_in_time()


func _init_additional_projectile():
	if _current_projectile_list.size() < _default_projectiles_amount:
		_new_polygon = _initial_object.duplicate()
		_current_projectile_list.append(_new_polygon)
		_new_polygon.global_position = _player_node.global_position
		_additional_projectiles_data[_new_polygon] = _AdditionalProjectileData.new(
			_direction_mouse_pos, _player_node.global_position
		)
		_player_location.add_child(_new_polygon)
		add_damage_signal(_cached_player_signal_function, _new_polygon)
	else:
		_timer_for_create_new_projetiles.stop()


func _physics_process(delta):
	_set_move_direction_every_frame(delta)

	_projectile_lifetime -= delta
	if _projectile_lifetime <= 0:
		can_use_spell = true
		_object_delete_from_scene()


func _object_delete_from_scene():
	for projectile in _current_projectile_list:
		projectile.queue_free()
	queue_free()


func _set_move_direction_every_frame(delta):
	for polygon in _current_projectile_list:
		_projectile_direction = _additional_projectiles_data[polygon].direction
		polygon.global_position += _projectile_direction * _projectile_speed * delta


func add_damage_signal(player_signal_function: Callable, spell_polygon: Polygon2D = spell_node):
	if not _cached_player_signal_function:
		_cached_player_signal_function = player_signal_function

	(
		spell_polygon
		. get_node("Area2D")
		. connect(
			"body_entered",
			player_signal_function.bind(base_damage),
		)
	)
