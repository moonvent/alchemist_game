extends Node

var current_spells: Dictionary[String, PackedScene] = {}

var first_spell: PackedScene = preload("res://scenes/spells/spells/arc.tscn")
var second_spell: PackedScene = preload("res://scenes/spells/spells/line.tscn")
var third_spell: PackedScene = preload("res://scenes/spells/spells/mini_line_queue.tscn")
var fourth_spell: PackedScene = preload("res://scenes/spells/spells/prolong_ray.tscn")

var spell_for_use: Spell

var used_spells: Dictionary[String, Spell] = {}

var player: Node2D


func _ready() -> void:
	current_spells["first_spell"] = first_spell
	current_spells["second_spell"] = second_spell
	current_spells["third_spell"] = third_spell
	current_spells["fourth_spell"] = fourth_spell


func use_spell(spell_number: String):
	if (
		used_spells.get(spell_number)
		and used_spells[spell_number].prolong_use
		and used_spells[spell_number].spell_is_active
	):
		spell_for_use = used_spells[spell_number]
		spell_for_use.update_spell_holding()

	else:
		spell_for_use = current_spells[spell_number].instantiate()

		if spell_for_use.can_use_spell:
			player.add_child(spell_for_use)
			spell_for_use.add_damage_signal(Callable(player.on_attack_collider_body_entered))
			used_spells[spell_number] = spell_for_use
