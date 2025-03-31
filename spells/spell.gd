extends Node2D

class_name Spell

var spell_name: String
var base_damage: int
var spell_node: Node2D

var can_use_spell: bool = true


func _ready() -> void:
	spell_node = $Spell


func add_damage_signal(player_signal_function: Callable):
	pass
