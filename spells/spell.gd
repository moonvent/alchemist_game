extends Node2D

class_name Spell

var spell_name: String
var base_damage: float
var spell_node: Node2D
# if spell need to prolong press for use
var prolong_use: bool = false

var only_one_intance_in_time: bool = true
static var can_use_spell: bool = true


func _ready() -> void:
	spell_node = $Spell
	_startup_mixins()


func update_spell_holding():
	pass


func add_damage_signal(player_signal_function: Callable):
	pass


func _startup_mixins():
	pass


func _process_mixins_before():
	pass


func _process_mixins_after():
	pass


func spell_is_active():
	return


func _spell_mixin_one_instance_in_time():
	# can have ONLY ONE instance when used
	if only_one_intance_in_time:
		can_use_spell = false


func _process_spell_mixin_look_at():
	# follow user cursor
	spell_node.look_at(get_global_mouse_position())
