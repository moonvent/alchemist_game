extends Node2D

class_name Spell

var spell_name: String
var base_damage: int
var spell_node: Node2D


func _ready() -> void:
	spell_node = $Spell
