extends Node

var current_spells: Dictionary[String, PackedScene] = {}

var first_spell: PackedScene = preload("res://scenes/spells/spells/arc.tscn")

var spell_for_use: Spell

var used_spells: Dictionary[String, Spell] = {}

var player: Node2D


func _ready() -> void:
	current_spells["first_spell"] = first_spell


func use_spell(spell_number: String):
	if used_spells.get(spell_number):
		if not used_spells[spell_number].can_use_spell:
			return
	spell_for_use = current_spells[spell_number].instantiate()
	player.add_child(spell_for_use)
	used_spells[spell_number] = spell_for_use
	spell_for_use.add_damage_signal(Callable(player.on_attack_collider_body_entered))
