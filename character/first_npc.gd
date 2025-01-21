extends "res://character/villager.gd"

var dialog_lines: Dictionary


func _ready() -> void:
	super._ready()
	dialog_lines = DialogJsonLoader.load_json_by_npc_name(name)


func activate_dialog_hover(body):
	if super.activate_dialog_hover(body):
		pass
