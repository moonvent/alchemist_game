extends Spell

class_name ProlongRaySpell

var _projectile_lifetime = 0.1

var collider: CollisionPolygon2D
var spell_area: Area2D

var _callback_for_deal_damage: Callable
var player: Player


func _ready() -> void:
	spell_name = "ProlongRay"
	base_damage = 0.05
	collider = $Spell/Area2D/CollisionPolygon2D
	spell_area = collider.get_parent()
	prolong_use = true
	player = find_parent("Player")
	super()


func _startup_mixins():
	_spell_mixin_one_instance_in_time()
	_process_spell_mixin_look_at()


func _process_mixins_before():
	_process_spell_mixin_look_at()


func _physics_process(delta):
	_process_mixins_before()

	_projectile_lifetime -= delta

	for body in spell_area.get_overlapping_bodies():
		body.make_damage(base_damage, player)

	if _projectile_lifetime <= 0:
		can_use_spell = true
		queue_free()


func update_spell_holding():
	_projectile_lifetime += get_physics_process_delta_time()  # or 0.017 is good for optimization


func spell_is_active():
	return bool(_projectile_lifetime)


func add_damage_signal(player_signal_function: Callable):
	_callback_for_deal_damage = player_signal_function
